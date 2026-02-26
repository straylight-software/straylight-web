-- | Straylight Server
-- Full-stack API server with PostgreSQL + ClickHouse
module Main where

import Network.Wai.Handler.Warp (run)

import Straylight.Env (initEnv)
import Straylight.Server (mkApp)

main :: IO ()
main = do
  putStrLn ""
  putStrLn "// straylight // server //"
  putStrLn ""
  
  -- Initialize environment (Postgres + ClickHouse)
  env <- initEnv
  
  putStrLn ""
  putStrLn "[server] Starting on http://localhost:8080"
  putStrLn ""
  
  -- Run the server
  run 8080 (mkApp env)
