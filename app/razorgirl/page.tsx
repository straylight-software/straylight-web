import { Header } from "@/components/header"
import { Footer } from "@/components/footer"

export default function RazorgirlPage() {
  return (
    <div className="min-h-screen bg-background text-muted-foreground text-[15px] leading-relaxed">
      <div className="scanline-overlay" />
      <Header />
      <main className="max-w-[900px] mx-auto px-8 py-12">
        <h1 className="text-primary text-[0.85rem] font-medium mb-8 lowercase section-header">
          <code>{`// razorgirl`}</code>
        </h1>
        
        <div className="bg-card border-l-[3px] border-l-primary px-6 py-4 my-6 quote-breathe">
          <div className="text-[0.75rem] text-muted-foreground uppercase tracking-wide mb-3 flex items-center gap-2">
            <span>i</span> GIBSON
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
            <span>i</span> TESSIER-ASHPOOL
          </div>
          <div className="text-text italic text-[0.9rem] leading-relaxed">
            &quot;Hans Becker is an Austrian video artist whose hallmark is an obsessive interrogation of rigidly delimited fields of visual information. His approaches range from classical montage to techniques borrowed from industrial espionage, deep-space imaging, and kino-archaeology.&quot;
          </div>
          <div className="mt-3 text-muted-foreground text-[0.9rem]">
            — Antarctica Starts Here, Net library intro-critique
          </div>
        </div>

        <div className="bg-card border-l-[3px] border-l-primary px-6 py-4 my-6 quote-breathe" style={{ animationDelay: '6s' }}>
          <div className="text-[0.75rem] text-muted-foreground uppercase tracking-wide mb-3 flex items-center gap-2">
            <span>i</span> GIBSON
          </div>
          <div className="text-text italic text-[0.9rem] leading-relaxed">
            &quot;Cyberspace. A consensual hallucination experienced daily by billions of legitimate operators, in every nation.&quot;
          </div>
        </div>

        <div className="bg-card border-l-[3px] border-l-status px-6 py-4 my-6 quote-breathe" style={{ animationDelay: '9s' }}>
          <div className="text-[0.75rem] text-muted-foreground uppercase tracking-wide mb-3 flex items-center gap-2">
            <span>i</span> GIBSON
          </div>
          <div className="text-text italic text-[0.9rem] leading-relaxed">
            &quot;The sky above the port was the color of television, tuned to a dead channel.&quot;
          </div>
        </div>

        <div className="bg-card border-l-[3px] border-l-primary px-6 py-4 my-6 quote-breathe" style={{ animationDelay: '12s' }}>
          <div className="text-[0.75rem] text-muted-foreground uppercase tracking-wide mb-3 flex items-center gap-2">
            <span>i</span> GIBSON
          </div>
          <div className="text-text italic text-[0.9rem] leading-relaxed">
            &quot;Night City was like a deranged experiment in social Darwinism, designed by a bored researcher who kept one thumb permanently on the fast-forward button.&quot;
          </div>
        </div>
        
        <p className="mb-4">it was the style that mattered and the style was the same.</p>
        <p className="mb-12">the moderns were mercenaries, practical jokers, <span className="text-text keyword keyword-3">nihilistic technofetishists</span>.</p>

        <h2 className="text-primary text-[0.85rem] font-medium mb-6 lowercase section-header" style={{ animationDelay: '4s' }}>
          <code>{`// assets`}</code>
        </h2>
        
        <div className="flex flex-col gap-4">
          <div className="grid grid-cols-[160px_1fr] gap-4 items-baseline group">
            <a 
              href="/assets/wallpaper-4k.png" 
              download
              className="text-text hover:text-primary transition-colors geo-hover"
            >
              wallpaper-4k.png
            </a>
            <span className="text-muted-foreground group-hover:text-text/70 transition-colors">desktop background. 3840x2160.</span>
          </div>
          <div className="grid grid-cols-[160px_1fr] gap-4 items-baseline group">
            <a 
              href="/assets/wallpaper-ultrawide.png" 
              download
              className="text-text hover:text-primary transition-colors geo-hover"
            >
              wallpaper-uw.png
            </a>
            <span className="text-muted-foreground group-hover:text-text/70 transition-colors">ultrawide. 3440x1440.</span>
          </div>
          <div className="grid grid-cols-[160px_1fr] gap-4 items-baseline group">
            <a 
              href="/assets/logo.svg" 
              download
              className="text-text hover:text-primary transition-colors geo-hover"
            >
              logo.svg
            </a>
            <span className="text-muted-foreground group-hover:text-text/70 transition-colors">vector mark.</span>
          </div>
          <div className="grid grid-cols-[160px_1fr] gap-4 items-baseline group">
            <a 
              href="/assets/agency-sheet.pdf" 
              download
              className="text-text hover:text-primary transition-colors geo-hover"
            >
              agency-sheet.pdf
            </a>
            <span className="text-muted-foreground group-hover:text-text/70 transition-colors">brand guidelines. ono-sendai / maas.</span>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  )
}
