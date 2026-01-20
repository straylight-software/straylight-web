import { Header } from "@/components/header"
import { Hero } from "@/components/hero"
import { Premise } from "@/components/premise"
import { Primitives } from "@/components/primitives"
import { Method } from "@/components/method"
import { Footer } from "@/components/footer"

export default function Home() {
  return (
    <div className="min-h-screen bg-background text-muted-foreground text-[15px] leading-relaxed">
      <div className="scanline-overlay" />
      <Header />
      <main className="max-w-[900px] mx-auto px-8">
        <Hero />
        <Premise />
        <Primitives />
        <Method />
      </main>
      <Footer />
    </div>
  )
}
