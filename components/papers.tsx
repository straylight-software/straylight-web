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

export function Plan() {
  return (
    <section id="plan" className="py-12 border-t border-border">
      <h2 className="text-primary text-[0.85rem] font-medium mb-6 lowercase section-header" style={{ animationDelay: '6s' }}>
        <code>{`// .plan`}</code>
      </h2>
      <div className="flex flex-col gap-4">
        {papers.map((paper) => (
          <Link
            key={paper.title}
            href="#"
            className="block p-4 bg-card border-l-[3px] border-l-transparent card-hover hover:bg-[#1f2328]"
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
    </section>
  )
}
