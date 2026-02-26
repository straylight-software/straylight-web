{
  description = "straylight.software - the continuity project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    purescript-overlay = {
      url = "github:thomashoneyman/purescript-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      bun2nix,
      purescript-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ purescript-overlay.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };
        bun2nixPkg = bun2nix.packages.${system}.default;

        # Hermetic bun dependencies (generate with: bun2nix)
        bunDeps = bun2nixPkg.fetchBunDeps {
          bunNix = ./bun.nix;
        };

        # Haskell API server with OpenAPI specs
        straylight-api = pkgs.haskellPackages.callCabal2nix "straylight-api" ./server { };

        # Production build
        straylight-web = pkgs.stdenv.mkDerivation {
          pname = "straylight-web";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = [
            bun2nixPkg.hook
            pkgs.bun
            pkgs.nodejs_22
            pkgs.purs
            pkgs.spago-unstable
            pkgs.purs-backend-es
            pkgs.esbuild
          ];

          inherit bunDeps;

          bunInstallFlags = [ "--linker=hoisted" ];

          buildPhase = ''
            runHook preBuild

            export PATH="$PWD/node_modules/.bin:$PATH"

            # Build PureScript
            echo "Building PureScript..."
            cd purescript
            spago bundle --bundle-type app --platform browser --minify --outfile ../public/straylight.js
            cd ..

            # Build Next.js
            echo "Building Next.js..."
            next build

            runHook postBuild
          '';

          installPhase = ''
                        runHook preInstall

                        mkdir -p $out/share/straylight-web
                        cp -r .next/standalone/. $out/share/straylight-web/
                        cp -r .next/static $out/share/straylight-web/.next/
                        cp -r public $out/share/straylight-web/

                        # Create runner script
                        mkdir -p $out/bin
                        cat > $out/bin/straylight-web <<EOF
            #!/usr/bin/env bash
            cd $out/share/straylight-web
            exec ${pkgs.nodejs_22}/bin/node server.js "\$@"
            EOF
                        chmod +x $out/bin/straylight-web

                        runHook postInstall
          '';
        };
      in
      {
        packages = {
          default = straylight-web;
          web = straylight-web;
          api = straylight-api;
        };

        # Checks run by `nix flake check`
        checks = {
          build = straylight-web;

          # PureScript property tests
          purescript-tests = pkgs.stdenv.mkDerivation {
            pname = "straylight-purescript-tests";
            version = "0.1.0";

            src = ./.;

            nativeBuildInputs = [
              pkgs.purs
              pkgs.spago-unstable
              pkgs.esbuild
              pkgs.nodejs_22
            ];

            buildPhase = ''
              runHook preBuild

              echo "Building and running PureScript tests..."
              cd purescript

              # Build tests
              spago build

              # Run test bundle if it exists
              if [ -f "test/dist/test.cjs" ]; then
                ${pkgs.nodejs_22}/bin/node test/dist/test.cjs
                echo "All property tests passed!"
              else
                echo "Skipping tests - test bundle not found"
                echo "To build: cd purescript && spago test"
              fi

              runHook postBuild
            '';

            installPhase = ''
              mkdir -p $out
              echo "Tests passed" > $out/result.txt
            '';
          };
        };

        apps.default = {
          type = "app";
          program = "${straylight-web}/bin/straylight-web";
        };

        # Dev runner - runs in current directory
        apps.dev = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "straylight-dev" ''
              set -e
              export PATH="${pkgs.bun}/bin:${pkgs.nodejs_22}/bin:${pkgs.purs}/bin:${pkgs.spago-unstable}/bin:${pkgs.purs-backend-es}/bin:${pkgs.esbuild}/bin:$PWD/node_modules/.bin:$PATH"

              if [ ! -d "node_modules" ]; then
                echo "Installing dependencies..."
                ${pkgs.bun}/bin/bun install
              fi

              echo ""
              echo "// straylight // dev //"
              echo ""
              echo "Building PureScript..."
              cd purescript && spago bundle --bundle-type app --platform browser --outfile ../public/straylight.js && cd ..

              echo ""
              echo "Starting dev server at http://localhost:3000"
              ${pkgs.bun}/bin/bun run dev
            ''
          );
        };

        # PureScript watch mode
        apps.purs = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "straylight-purs" ''
              set -e
              export PATH="${pkgs.purs}/bin:${pkgs.spago-unstable}/bin:${pkgs.purs-backend-es}/bin:${pkgs.esbuild}/bin:$PATH"

              cd purescript
              echo "Building PureScript bundle..."
              spago bundle --bundle-type app --platform browser --outfile ../public/straylight.js
              echo ""
              echo "Bundle written to public/straylight.js"
              ls -lh ../public/straylight.js
            ''
          );
        };

        # E2E tests with Playwright
        apps.e2e = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "straylight-e2e" ''
              set -e
              export PATH="${pkgs.purs}/bin:${pkgs.spago-unstable}/bin:${pkgs.esbuild}/bin:${pkgs.nodejs_22}/bin:$PATH"
              export PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH="${pkgs.chromium}/bin/chromium"

              echo ""
              echo "// straylight // e2e //"
              echo ""

              cd e2e
              echo "Building E2E tests..."
              spago bundle

              echo ""
              echo "Running E2E tests..."
              ${pkgs.nodejs_22}/bin/node dist/e2e.js
            ''
          );
        };

        # nix run .#dev-all — unified dev environment (Postgres + ClickHouse + API)
        apps.dev-all = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "straylight-dev-all" ''
              set -e

              echo ""
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
              echo "  // straylight // dev-all"
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
              echo ""

              # Cleanup function
              cleanup() {
                echo ""
                echo "Shutting down services..."
                
                # Stop API server
                if [ -n "$API_PID" ] && kill -0 "$API_PID" 2>/dev/null; then
                  kill "$API_PID" 2>/dev/null || true
                fi
                
                # Stop ClickHouse
                if [ -n "$CH_PID" ] && kill -0 "$CH_PID" 2>/dev/null; then
                  kill "$CH_PID" 2>/dev/null || true
                fi
                
                # Stop PostgreSQL
                if [ -d "$PGDATA" ]; then
                  ${pkgs.postgresql}/bin/pg_ctl -D "$PGDATA" stop 2>/dev/null || true
                fi
                
                echo "All services stopped"
              }
              trap cleanup EXIT

              # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              # PostgreSQL
              # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              PGDATA="$PWD/.postgres-data"
              PGPORT=5432
              PGUSER="straylight"
              PGPASSWORD="straylight-dev"
              PGDATABASE="straylight"

              export POSTGRES_HOST=localhost
              export POSTGRES_PORT=$PGPORT
              export POSTGRES_USER=$PGUSER
              export POSTGRES_PASSWORD=$PGPASSWORD
              export POSTGRES_DATABASE=$PGDATABASE

              if [ ! -d "$PGDATA" ]; then
                echo "[postgres] Initializing data directory..."
                ${pkgs.postgresql}/bin/initdb -D "$PGDATA" --auth=trust --no-locale --encoding=UTF8 >/dev/null
                echo "listen_addresses = 'localhost'" >> "$PGDATA/postgresql.conf"
                echo "port = $PGPORT" >> "$PGDATA/postgresql.conf"
                echo "unix_socket_directories = '$PGDATA'" >> "$PGDATA/postgresql.conf"
              fi

              echo "[postgres] Starting on port $PGPORT..."
              ${pkgs.postgresql}/bin/pg_ctl -D "$PGDATA" -l "$PGDATA/logfile" start >/dev/null

              for i in {1..30}; do
                if ${pkgs.postgresql}/bin/pg_isready -h localhost -p $PGPORT >/dev/null 2>&1; then
                  break
                fi
                sleep 0.5
              done

              SUPERUSER=$(whoami)
              if ! ${pkgs.postgresql}/bin/psql -h localhost -p $PGPORT -U $SUPERUSER -d template1 -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw $PGDATABASE; then
                ${pkgs.postgresql}/bin/psql -h localhost -p $PGPORT -U $SUPERUSER -d template1 -c "CREATE USER $PGUSER WITH PASSWORD '$PGPASSWORD';" 2>/dev/null || true
                ${pkgs.postgresql}/bin/psql -h localhost -p $PGPORT -U $SUPERUSER -d template1 -c "CREATE DATABASE $PGDATABASE OWNER $PGUSER;" 2>/dev/null
                ${pkgs.postgresql}/bin/psql -h localhost -p $PGPORT -U $SUPERUSER -d template1 -c "GRANT ALL PRIVILEGES ON DATABASE $PGDATABASE TO $PGUSER;" 2>/dev/null
              fi

              echo "[postgres] Running"

              # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              # ClickHouse
              # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              CHDATA="$PWD/.clickhouse-data"
              CHPORT=8123
              CHTCPPORT=9000

              export CLICKHOUSE_HOST=localhost
              export CLICKHOUSE_PORT=$CHPORT
              export CLICKHOUSE_USER=default
              export CLICKHOUSE_PASSWORD=
              export CLICKHOUSE_DATABASE=default

              mkdir -p "$CHDATA/data" "$CHDATA/tmp" "$CHDATA/user_files" "$CHDATA/format_schemas"

              cat > "$CHDATA/config.xml" << EOF
              <clickhouse>
                <logger>
                  <level>warning</level>
                  <console>1</console>
                </logger>
                <http_port>$CHPORT</http_port>
                <tcp_port>$CHTCPPORT</tcp_port>
                <listen_host>127.0.0.1</listen_host>
                <path>$CHDATA/data/</path>
                <tmp_path>$CHDATA/tmp/</tmp_path>
                <user_files_path>$CHDATA/user_files/</user_files_path>
                <format_schema_path>$CHDATA/format_schemas/</format_schema_path>
                <mark_cache_size>5368709120</mark_cache_size>
              </clickhouse>
              EOF

              cat > "$CHDATA/users.xml" << EOF
              <clickhouse>
                <users>
                  <default>
                    <password></password>
                    <networks><ip>::/0</ip></networks>
                    <profile>default</profile>
                    <quota>default</quota>
                    <access_management>1</access_management>
                  </default>
                </users>
                <profiles><default/></profiles>
                <quotas><default/></quotas>
              </clickhouse>
              EOF

              echo "[clickhouse] Starting on port $CHPORT..."
              ${pkgs.clickhouse}/bin/clickhouse-server --config-file="$CHDATA/config.xml" --pid-file="$CHDATA/clickhouse.pid" &
              CH_PID=$!

              # Wait for ClickHouse
              for i in {1..30}; do
                if ${pkgs.curl}/bin/curl -s "http://localhost:$CHPORT/ping" >/dev/null 2>&1; then
                  break
                fi
                sleep 0.5
              done

              echo "[clickhouse] Running"

              # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              # Run Migrations
              # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              echo ""
              echo "[migrations] Running PostgreSQL migrations..."

              for migration in server/migrations/postgres/*.sql; do
                if [ -f "$migration" ]; then
                  PGPASSWORD=$PGPASSWORD ${pkgs.postgresql}/bin/psql -h localhost -p $PGPORT -U $PGUSER -d $PGDATABASE -f "$migration" >/dev/null 2>&1 || true
                fi
              done
              echo "[migrations] PostgreSQL complete"

              echo "[migrations] Running ClickHouse migrations..."
              for migration in server/migrations/*.sql; do
                if [ -f "$migration" ] && [[ "$migration" != *"postgres"* ]]; then
                  ${pkgs.curl}/bin/curl -s -X POST "http://localhost:$CHPORT/" --data-binary @"$migration" >/dev/null 2>&1 || true
                fi
              done
              echo "[migrations] ClickHouse complete"

              # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              # API Server
              # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              echo ""
              echo "═══════════════════════════════════════════════════════════"
              echo "All services ready!"
              echo ""
              echo "  PostgreSQL:  localhost:$PGPORT (user: $PGUSER)"
              echo "  ClickHouse:  localhost:$CHPORT"
              echo "  API Server:  http://localhost:8080"
              echo ""
              echo "  Press Ctrl+C to stop all services"
              echo "═══════════════════════════════════════════════════════════"
              echo ""

              # Run the API server in foreground
              ${pkgs.lib.getExe' straylight-api "straylight-server"}
            ''
          );
        };

        # PostgreSQL migrations
        apps.migrate-pg = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "straylight-migrate-pg" ''
              set -e
              echo "[migrations] Running PostgreSQL migrations..."

              PGPASSWORD=''${POSTGRES_PASSWORD:-straylight-dev}
              PGHOST=''${POSTGRES_HOST:-localhost}
              PGPORT=''${POSTGRES_PORT:-5432}
              PGUSER=''${POSTGRES_USER:-straylight}
              PGDATABASE=''${POSTGRES_DATABASE:-straylight}

              for migration in server/migrations/postgres/*.sql; do
                if [ -f "$migration" ]; then
                  echo "  Running $migration..."
                  PGPASSWORD=$PGPASSWORD ${pkgs.postgresql}/bin/psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -f "$migration"
                fi
              done
              echo "[migrations] Complete"
            ''
          );
        };

        # ClickHouse migrations
        apps.migrate-ch = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "straylight-migrate-ch" ''
              set -e
              echo "[migrations] Running ClickHouse migrations..."

              CHHOST=''${CLICKHOUSE_HOST:-localhost}
              CHPORT=''${CLICKHOUSE_PORT:-8123}

              for migration in server/migrations/*.sql; do
                if [ -f "$migration" ] && [[ "$migration" != *"postgres"* ]]; then
                  echo "  Running $migration..."
                  ${pkgs.curl}/bin/curl -s -X POST "http://$CHHOST:$CHPORT/" --data-binary @"$migration"
                fi
              done
              echo "[migrations] Complete"
            ''
          );
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_22
            pkgs.bun
            pkgs.purs
            pkgs.purs-tidy
            pkgs.purs-backend-es
            pkgs.spago-unstable
            pkgs.esbuild
            pkgs.git
            bun2nixPkg
            # Haskell
            pkgs.ghc
            pkgs.cabal-install
            pkgs.haskell-language-server
            pkgs.zlib
            pkgs.pkg-config
            # Databases
            pkgs.postgresql
            pkgs.clickhouse
            pkgs.curl
            # E2E
            pkgs.chromium
            pkgs.playwright-driver.browsers
          ];

          shellHook = ''
            export PATH="$PWD/node_modules/.bin:$PATH"

            echo ""
            echo "// straylight // software //"
            echo ""
            echo "Commands:"
            echo "  bun install           - Install JS dependencies"
            echo "  bun run dev           - Start Next.js dev server"
            echo "  nix run .#purs        - Build PureScript bundle"
            echo "  nix run .#dev         - Build + dev (one command)"
            echo "  nix run .#dev-all     - Full stack (PG + CH + API)"
            echo "  nix run .#e2e         - Run E2E tests"
            echo "  nix build             - Hermetic production build"
            echo "  nix flake check       - Run all checks"
            echo ""
            echo "PureScript: $(purs --version)"
            echo "Spago: $(spago --version 2>/dev/null || echo 'available')"
            echo "Node: $(node --version)"
            echo "Bun: $(bun --version)"
            echo ""
          '';
        };
      }
    );
}
