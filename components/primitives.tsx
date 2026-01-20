export function Primitives() {
  const items = [
    { name: "orthogonal.", desc: "one thing, well.", keywordClass: "keyword-5" },
    { name: "composable.", desc: "outputs are inputs.", keywordClass: "keyword-6" },
    { name: "deterministic.", desc: "same input, same hash, same artifact.", keywordClass: "keyword-7" },
  ]

  return (
    <section className="py-12 border-t border-border">
      <h2 className="text-primary text-[0.85rem] font-medium mb-6 lowercase section-header" style={{ animationDelay: '2s' }}>
        <code>{`// primitives`}</code>
      </h2>
      <div className="flex flex-col gap-2">
        {items.map((item) => (
          <div key={item.name} className="grid grid-cols-[140px_1fr] gap-4">
            <span className={`text-text keyword ${item.keywordClass}`}>{item.name}</span>
            <span>{item.desc}</span>
          </div>
        ))}
      </div>
    </section>
  )
}
