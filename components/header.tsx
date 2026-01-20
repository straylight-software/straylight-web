import Link from "next/link"
import { ThemeSwitcher } from "./theme-switcher"

export function Header() {
  return (
    <header className="sticky top-0 z-50 bg-background border-b border-border">
      <div className="max-w-[900px] mx-auto px-8 py-4">
        <div className="flex justify-between items-center">
          <ThemeSwitcher />
          
          <nav className="flex items-center gap-6">
            <Link 
              href="/plan" 
              className="text-muted-foreground text-[13px] hover:text-text transition-colors link-trace"
            >
              .plan
            </Link>
            <Link 
              href="/razorgirl" 
              className="text-muted-foreground text-[13px] hover:text-text transition-colors link-trace"
            >
              razorgirl
            </Link>
            <Link 
              href="/software" 
              className="text-muted-foreground text-[13px] hover:text-text transition-colors link-trace"
            >
              software
            </Link>
            <Link 
              href="https://github.com/straylight-software" 
              className="text-muted-foreground text-[13px] hover:text-text transition-colors link-trace"
              target="_blank"
              rel="noopener noreferrer"
            >
              github
            </Link>
            <Link 
              href="https://tangled.sh/straylight.software" 
              className="text-muted-foreground text-[13px] hover:text-text transition-colors link-trace"
              target="_blank"
              rel="noopener noreferrer"
            >
              tangled
            </Link>
            <Link 
              href="/irc" 
              className="text-muted-foreground text-[13px] hover:text-text transition-colors link-trace"
            >
              irc
            </Link>
            <Link 
              href="/discord" 
              className="text-muted-foreground text-[13px] hover:text-text transition-colors link-trace"
            >
              discord
            </Link>
          </nav>

          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <span className="w-2 h-2 bg-status inline-block status-pulse" />
            NOMINAL
          </div>
        </div>
      </div>
    </header>
  )
}
