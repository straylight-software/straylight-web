import Link from "next/link"
import { RotatingQuote } from "./rotating-quote"

export function Footer() {
  return (
    <footer className="border-t border-border py-12">
      <div className="max-w-[900px] mx-auto px-8 text-right">
        <RotatingQuote />
        <div className="mt-4 text-[0.85rem]">
          <Link 
            href="https://github.com/straylight-software" 
            className="text-muted-foreground hover:text-text transition-colors ml-6 link-float inline-block"
            target="_blank"
            rel="noopener noreferrer"
          >
            github
          </Link>
          <Link 
            href="https://weyl.ai" 
            className="text-muted-foreground hover:text-text transition-colors ml-6 link-float inline-block"
            target="_blank"
            rel="noopener noreferrer"
          >
            weyl.ai
          </Link>
          <Link 
            href="https://fleek.sh" 
            className="text-muted-foreground hover:text-text transition-colors ml-6 link-float inline-block"
            target="_blank"
            rel="noopener noreferrer"
          >
            fleek.sh
          </Link>
        </div>
      </div>
    </footer>
  )
}
