export function Razorgirl() {
  return (
    <section id="razorgirl" className="py-12 border-t border-border">
      <h2 className="text-primary text-[0.85rem] font-medium mb-6 lowercase section-header" style={{ animationDelay: '8s' }}>
        <code>{`// razorgirl`}</code>
      </h2>
      
      <div className="bg-card border-l-[3px] border-l-primary px-6 py-4 my-6 quote-breathe">
        <div className="text-[0.75rem] text-muted-foreground uppercase tracking-wide mb-3 flex items-center gap-2">
          <span>ℹ</span> GIBSON
        </div>
        <div className="text-text italic">
          &quot;The Panther Moderns differ from other terrorists precisely in their degree of self-consciousness, in their awareness of the extent to which media divorce the act of terrorism from the original sociopolitical intent.&quot;
        </div>
        <div className="mt-3 text-muted-foreground text-[0.9rem]">
          &quot;Skip it,&quot; Case said.
        </div>
      </div>

      <div className="bg-card border-l-[3px] border-l-status px-6 py-4 my-6 quote-breathe" style={{ animationDelay: '3s' }}>
        <div className="text-[0.75rem] text-muted-foreground uppercase tracking-wide mb-3 flex items-center gap-2">
          <span>ℹ</span> TESSIER-ASHPOOL
        </div>
        <div className="text-text italic text-[0.9rem] leading-relaxed">
          &quot;Hans Becker is an Austrian video artist whose hallmark is an obsessive interrogation of rigidly delimited fields of visual information. His approaches range from classical montage to techniques borrowed from industrial espionage, deep-space imaging, and kino-archaeology.&quot;
        </div>
        <div className="mt-3 text-muted-foreground text-[0.9rem]">
          — Antarctica Starts Here, Net library intro-critique
        </div>
      </div>
      
      <p className="mb-4">it was the style that mattered and the style was the same.</p>
      <p>the moderns were mercenaries, practical jokers, <span className="text-text keyword keyword-3">nihilistic technofetishists</span>.</p>
    </section>
  )
}
