import { Header } from "@/components/header"
import { Footer } from "@/components/footer"
import Link from "next/link"

export default function DiscordPage() {
  return (
    <div className="min-h-screen bg-background text-muted-foreground text-[15px] leading-relaxed">
      <div className="scanline-overlay" />
      <Header />
      <main className="max-w-[900px] mx-auto px-8 py-12">
        <h1 className="text-primary text-[0.85rem] font-medium mb-8 lowercase section-header">
          <code>{`// discord`}</code>
        </h1>
        
        <p className="mb-6">
          real-time coordination. less formal than irc.
        </p>

        <Link 
          href="https://discord.gg/straylight" 
          className="inline-block text-text hover:text-primary transition-colors geo-hover"
          target="_blank"
          rel="noopener noreferrer"
        >
          discord.gg/straylight
        </Link>
      </main>
      <Footer />
    </div>
  )
}
