export function Hero() {
  return (
    <section className="py-24 pb-16 text-right">
      <div className="h-[3px] rail mb-6" />
      <h1 className="text-text text-[2rem] font-medium">
        <span className="text-primary">{'//'}</span> straylight <span className="text-primary">{'//'}</span> software <span className="text-primary">{'//'}</span>
      </h1>
      <div className="h-[3px] rail mt-6" />
      
      <p className="mt-12 text-left text-lg text-muted-foreground hover:text-text transition-colors duration-200 cursor-default">
        the continuity project.
      </p>
      <p className="mt-6 text-left italic text-base02 text-[0.95rem] hover:text-text transition-colors duration-200 cursor-default">
        continuity is continuity. continuity is continuity&apos;s job.
      </p>
    </section>
  )
}
