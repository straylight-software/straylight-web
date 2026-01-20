"use client"

import { useState, useRef, useEffect } from "react"
import { useTheme, type Theme } from "./theme-provider"

const themes: { id: Theme; name: string; series: string; desc: string }[] = [
  // Ono-Sendai Dark Series
  { id: "ono-tuned", name: "TUNED", series: "ono-sendai", desc: "HSL perceptual / daily driver" },
  { id: "ono-sprawl", name: "SPRAWL", series: "ono-sendai", desc: "carbon black / best compromise" },
  { id: "ono-memphis", name: "MEMPHIS", series: "ono-sendai", desc: "true black / OLED perfect" },
  { id: "ono-github", name: "GITHUB", series: "ono-sendai", desc: "robust default / maximum compat" },
  // MAAS Light Series
  { id: "maas-neoform", name: "NEOFORM", series: "maas", desc: "clean room schematics / daily driver" },
  { id: "maas-bioptic", name: "BIOPTIC", series: "maas", desc: "warm cream paper / long reading" },
  { id: "maas-ghost", name: "GHOST", series: "maas", desc: "low contrast / photosensitivity" },
  { id: "maas-tessier", name: "TESSIER", series: "maas", desc: "maximum contrast / clinical QA" },
]

export function ThemeSwitcher() {
  const { theme, setTheme } = useTheme()
  const [isOpen, setIsOpen] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }
    document.addEventListener("mousedown", handleClickOutside)
    return () => document.removeEventListener("mousedown", handleClickOutside)
  }, [])

  const onoThemes = themes.filter(t => t.series === "ono-sendai")
  const maasThemes = themes.filter(t => t.series === "maas")

  return (
    <div className="relative" ref={menuRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="text-text font-medium text-sm hover:text-primary transition-colors geo-hover cursor-pointer"
      >
        <span className="text-primary">{'//'}</span> straylight <span className="text-primary">{'//'}</span>
      </button>

      {isOpen && (
        <div className="absolute top-full left-0 mt-2 bg-card border border-border p-4 min-w-[320px] z-50 theme-menu">
          <div className="text-[10px] text-muted-foreground uppercase tracking-widest mb-3">
            // chromatic series
          </div>

          {/* Ono-Sendai Dark */}
          <div className="mb-4">
            <div className="text-[9px] text-primary uppercase tracking-wider mb-2 flex items-center gap-2">
              <span className="w-1.5 h-1.5 bg-primary inline-block" />
              ONO-SENDAI DARK
            </div>
            <div className="flex flex-col gap-1">
              {onoThemes.map((t) => (
                <button
                  key={t.id}
                  onClick={() => { setTheme(t.id); setIsOpen(false) }}
                  className={`text-left px-2 py-1.5 transition-colors flex items-center justify-between group ${
                    theme === t.id 
                      ? "bg-primary/10 text-text" 
                      : "hover:bg-card text-muted-foreground hover:text-text"
                  }`}
                >
                  <span className="text-[11px]">{t.name}</span>
                  <span className="text-[9px] text-muted-foreground group-hover:text-base02">{t.desc}</span>
                </button>
              ))}
            </div>
          </div>

          {/* MAAS Light */}
          <div>
            <div className="text-[9px] text-status uppercase tracking-wider mb-2 flex items-center gap-2">
              <span className="w-1.5 h-1.5 bg-status inline-block" />
              MAAS BIOLABS LIGHT
            </div>
            <div className="flex flex-col gap-1">
              {maasThemes.map((t) => (
                <button
                  key={t.id}
                  onClick={() => { setTheme(t.id); setIsOpen(false) }}
                  className={`text-left px-2 py-1.5 transition-colors flex items-center justify-between group ${
                    theme === t.id 
                      ? "bg-primary/10 text-text" 
                      : "hover:bg-card text-muted-foreground hover:text-text"
                  }`}
                >
                  <span className="text-[11px]">{t.name}</span>
                  <span className="text-[9px] text-muted-foreground group-hover:text-base02">{t.desc}</span>
                </button>
              ))}
            </div>
          </div>

          <div className="mt-4 pt-3 border-t border-border">
            <div className="text-[8px] text-muted-foreground uppercase tracking-wider">
              211° hue lock / base16 compatible
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
