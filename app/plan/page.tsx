import { Header } from "@/components/header"
import { Footer } from "@/components/footer"
import Link from "next/link"

const papers = [
  {
    title: "The Villa Straylight Papers",
    meta: "January 8, 2026 // Weyl Team // 13 min read",
    tags: ["CUDA", "NVIDIA", "TENSOR CORES", "NEUROMANCER"],
  },
  {
    title: "Typed Unix: Zero Bash",
    meta: "Coming // Weyl Team",
    tags: ["HASKELL", "SYSTEM Fω", "ALEPH"],
  },
  {
    title: "The Scope Graph Is The Immune System",
    meta: "Coming // Weyl Team",
    tags: ["ZEITSCHRIFT", "LEAN4", "VISSER"],
  },
]

export default function PlanPage() {
  return (
    <div className="min-h-screen bg-background text-muted-foreground text-[15px] leading-relaxed">
      <div className="scanline-overlay" />
      <Header />
      <main className="max-w-[900px] mx-auto px-8 py-12">
        <h1 className="text-primary text-[0.85rem] font-medium mb-8 lowercase section-header">
          <code>{`// .plan`}</code>
        </h1>
        <div className="flex flex-col gap-4">
          {papers.map((paper) => (
            <Link
              key={paper.title}
              href="#"
              className="block p-4 bg-card border-l-[3px] border-l-transparent card-hover hover:bg-secondary"
            >
              <div className="text-text font-medium mb-2">{paper.title}</div>
              <div className="text-[0.85rem] text-muted-foreground">{paper.meta}</div>
              <div className="mt-2 text-[0.8rem]">
                {paper.tags.map((tag) => (
                  <span key={tag} className="text-primary mr-2">
                    {`// ${tag} //`}
                  </span>
                ))}
              </div>
            </Link>
          ))}
        </div>
      </main>
      <Footer />
    </div>
  )
}
