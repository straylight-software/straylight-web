import { Header } from "@/components/header"
import { Footer } from "@/components/footer"

export default function IRCPage() {
  return (
    <div className="min-h-screen bg-background text-muted-foreground text-[15px] leading-relaxed">
      <div className="scanline-overlay" />
      <Header />
      <main className="max-w-[900px] mx-auto px-8 py-12">
        <h1 className="text-primary text-[0.85rem] font-medium mb-8 lowercase section-header">
          <code>{`// irc`}</code>
        </h1>
        
        <div className="flex flex-col gap-4">
          <div className="grid grid-cols-[100px_1fr] gap-4 items-baseline">
            <span className="text-text">network</span>
            <span className="text-muted-foreground">libera.chat</span>
          </div>
          <div className="grid grid-cols-[100px_1fr] gap-4 items-baseline">
            <span className="text-text">channel</span>
            <span className="text-muted-foreground">#straylight</span>
          </div>
        </div>

        <pre className="bg-card p-4 mt-6 overflow-x-auto text-[0.9rem]">
          <code className="text-muted-foreground">
            <span className="text-primary">/connect</span> irc.libera.chat{'\n'}
            <span className="text-primary">/join</span> #straylight
          </code>
        </pre>
      </main>
      <Footer />
    </div>
  )
}
