import { Header } from "@/components/header"
import { Footer } from "@/components/footer"
import Link from "next/link"

const projects = [
  {
    name: "nix",
    desc: "our fork. correct, modern, apolitical.",
  },
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

export default function SoftwarePage() {
  return (
    <div className="min-h-screen bg-background text-muted-foreground text-[15px] leading-relaxed">
      <div className="scanline-overlay" />
      <Header />
      <main className="max-w-[900px] mx-auto px-8 py-12">
        <h1 className="text-primary text-[0.85rem] font-medium mb-8 lowercase section-header">
          <code>{`// software`}</code>
        </h1>
        <div className="flex flex-col gap-6">
          {projects.map((project) => (
            <div key={project.name} className="grid grid-cols-[140px_1fr] gap-4 items-baseline group">
              <Link 
                href={`https://github.com/straylight-software/${project.name}`}
                target="_blank"
                rel="noopener noreferrer"
                className="text-text hover:text-primary transition-colors geo-hover"
              >
                {project.name}
              </Link>
              <span className="text-muted-foreground group-hover:text-text/70 transition-colors">{project.desc}</span>
            </div>
          ))}
        </div>
      </main>
      <Footer />
    </div>
  )
}
