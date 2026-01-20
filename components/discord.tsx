import Link from "next/link"

export function Discord() {
  return (
    <section id="discord" className="py-12 border-t border-border">
      <h2 className="text-primary text-[0.85rem] font-medium mb-6 lowercase section-header" style={{ animationDelay: '10s' }}>
        <code>{`// discord`}</code>
      </h2>
      
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
    </section>
  )
}
