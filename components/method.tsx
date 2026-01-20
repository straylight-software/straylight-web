export function Method() {
  return (
    <section className="py-12 border-t border-border">
      <h2 className="text-primary text-[0.85rem] font-medium mb-6 lowercase section-header" style={{ animationDelay: '3s' }}>
        <code>{`// method`}</code>
      </h2>
      <pre className="bg-card p-4 overflow-x-auto text-[0.9rem] leading-relaxed">
        <code className="text-muted-foreground">razorgirl on railgun ~</code>
{`
`}<code className="text-muted-foreground">❯ </code><code className="text-text">{`ssh -A anywhere.straylight.software \\
  'nix run -L github:straylight-software/isospin-builder -- nvidia-sdk | straylight-cas'`}</code><span className="block-cursor" />
      </pre>
      <p className="mt-6 text-text"><span className="keyword keyword-1">conceptual computers</span> are free now.</p>
    </section>
  )
}
