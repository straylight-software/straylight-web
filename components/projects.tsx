import Link from "next/link"

const projects = [
  {
    name: "aleph",
    desc: "typed infrastructure. System Fω. droids ship code that works.",
  },
  {
    name: "zeitschrift",
    desc: "scope graph publishing. references resolve or the build fails.",
  },
  {
    name: "isospin-microvm",
    desc: "microvm orchestration. GPUs appear inside firecracker.",
  },
  {
    name: "hacker-flake",
    desc: "nix flake for NVIDIA dev. just compile some shit.",
  },
]

export function Software() {
  return (
    <section id="software" className="py-12 border-t border-border">
      <h2 className="text-primary text-[0.85rem] font-medium mb-6 lowercase section-header" style={{ animationDelay: '4s' }}>
        <code>{`// software`}</code>
      </h2>
      <div className="flex flex-col gap-6">
        {projects.map((project) => (
          <div key={project.name} className="grid grid-cols-[140px_1fr] gap-4 items-baseline group">
            <Link 
              href="#" 
              className="text-text hover:text-primary transition-colors geo-hover"
            >
              {project.name}
            </Link>
            <span className="text-muted-foreground group-hover:text-text/70 transition-colors">{project.desc}</span>
          </div>
        ))}
      </div>
    </section>
  )
}
