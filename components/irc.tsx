export function IRC() {
  return (
    <section id="irc" className="py-12 border-t border-border">
      <h2 className="text-primary text-[0.85rem] font-medium mb-6 lowercase section-header" style={{ animationDelay: '9s' }}>
        <code>{`// irc`}</code>
      </h2>
      
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
    </section>
  )
}
