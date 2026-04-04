// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  RenderCV – "nilton" theme                                               ║
// ║  Two-column sidebar layout, matching CV_nilton_teixeira_en.pdf           ║
// ╚══════════════════════════════════════════════════════════════════════════╝

// ─── Colors ──────────────────────────────────────────────────────────────────
#let c-primary    = rgb("#1E40AE")   // Blue – name, badges, date text
#let c-dark       = rgb("#1E293B")   // Dark navy – headings, body
#let c-sidebar-bg = rgb("#EEF2F8")   // Subtle blue-gray – sidebar fill
#let c-divider    = rgb("#CBD5E1")   // Muted blue-gray – rule lines

// ─── Page ────────────────────────────────────────────────────────────────────
#set page(
  paper:      "us-legal",
  margin:     0pt,
  background: [
    #place(left + top,
      rect(fill: c-sidebar-bg, width: 6.8cm, height: 100%)
    )
  ],
)

// ─── Typography ──────────────────────────────────────────────────────────────
#set text(
  font:    ("Helvetica Neue", "Helvetica", "Arial", "Liberation Sans", "Noto Sans"),
  size:    9.5pt,
  fill:    c-dark,
  lang:    "en",
)
#set par(leading: 0.6em, justify: false)
#set list(indent: 0pt, body-indent: 0.4em)

// ─── Helpers ─────────────────────────────────────────────────────────────────

// Skill pill badge
#let badge(lbl) = box(
  fill:   c-primary,
  radius: 3pt,
  inset:  (x: 5pt, y: 2.5pt),
  text(fill: white, size: 8pt, weight: "regular", lbl),
)

// Sidebar section heading
#let sb-heading(t) = {
  v(0.32cm)
  text(size: 7.5pt, weight: "bold", fill: c-dark.lighten(25%), upper(t))
  v(0.05cm)
  line(length: 100%, stroke: 0.5pt + c-divider)
  v(0.15cm)
}

// Main column section heading
#let main-heading(t) = {
  v(0.3cm)
  text(size: 10pt, weight: "bold", fill: c-dark, upper(t))
  v(-0.1cm)
  line(length: 100%, stroke: 0.5pt + c-divider)
  v(0.12cm)
}

// ─── Page grid ───────────────────────────────────────────────────────────────
#grid(
  columns: (6.8cm, 1fr),

  // ══ LEFT: sidebar ══════════════════════════════════════════════════════════
  pad(x: 0.65cm, y: 0.75cm)[

    // Name
    #text(size: 15pt, weight: "bold", fill: c-primary)[{{ cv.name }}]
    #v(0.1cm)

    // Headline / title
    #text(size: 11pt, weight: "bold", fill: c-dark)[{{ cv.headline }}]
    #v(0.35cm)

    // Contact
    #sb-heading("CONTACT")
    #set text(size: 8.5pt)
    {% if cv.email %}
    {{ cv.email | replace("@", "\\@") }} \
    {% endif %}
    {% if cv.phone %}
    {{ cv.phone | replace("tel:", "") | replace("mailto:", "") }} \
    {% endif %}
    {% if cv.location %}
    {{ cv.location | replace("/", "\\/") }}
    {% endif %}

    {% for section in cv.rendercv_sections %}
    {% if section.snake_case_title == "skills" %}
    // ── Technical Skills (badge pills) ───────────────────────────────────
    #sb-heading("TECHNICAL SKILLS")
    {% for entry in section.entries %}
    {% for skill in entry.details.split(", ") %}
    #badge([{{ skill.strip() }}]) #h(2pt)
    {% endfor %}
    #v(0.09cm)
    {% endfor %}

    {% elif section.snake_case_title == "soft_skills" %}
    // ── Soft Skills ───────────────────────────────────────────────────────
    #sb-heading("SOFT SKILLS")
    #set text(size: 8.5pt)
    {% for entry in section.entries %}
    • #[{{ entry.bullet }}] \
    {% endfor %}

    {% elif section.snake_case_title == "languages" %}
    // ── Languages ─────────────────────────────────────────────────────────
    #sb-heading("LANGUAGES")
    #set text(size: 8.5pt)
    {% for entry in section.entries %}
    #[{{ entry.bullet }}] \
    {% endfor %}

    {% elif section.snake_case_title == "interests" %}
    // ── Interests ─────────────────────────────────────────────────────────
    #sb-heading("INTERESTS")
    #set text(size: 8.5pt)
    {% for entry in section.entries %}
    • #[{{ entry.bullet }}] \
    {% endfor %}

    {% endif %}
    {% endfor %}

    // ── Social ────────────────────────────────────────────────────────────
    #sb-heading("SOCIAL")
    #set text(size: 8.5pt)
    {% for sn in cv.social_networks %}
    #text(fill: c-primary)[{{ sn.network }}:] {{ sn.username }} \
    {% endfor %}
  ],

  // ══ RIGHT: main content ════════════════════════════════════════════════════
  pad(x: 0.65cm, y: 0.75cm)[
    {% for section in cv.rendercv_sections %}
    {% if section.snake_case_title not in ["skills", "soft_skills", "languages", "interests"] %}
    // Section: {{ section.title }}
    #main-heading("{{ section.title }}")

    {% if section.entry_type == "TextEntry" %}
    // ── About / text paragraphs ───────────────────────────────────────────
    {% for entry in section.entries %}
    #par(justify: true)[{{ entry }}]
    #v(0.15cm)
    {% endfor %}

    {% elif section.entry_type in ["ExperienceEntry", "NormalEntry"] %}
    // ── Experience entries ────────────────────────────────────────────────
    {% for entry in section.entries %}
    {% set mc_lines = entry.main_column.splitlines() %}
    {% set dal_lines = entry.date_and_location_column.splitlines() %}
    #block(below: 0.9em)[
      // Header row: position (left) · location (right)
      #grid(
        columns: (1fr, auto),
        column-gutter: 0.3cm,
        align: (left + top, right + top),
        // position line
        text(size: 9.5pt, weight: "regular")[{{ mc_lines[0] if mc_lines else "" }}],
        // location
        text(size: 8pt, style: "italic")[{{ dal_lines[0] if dal_lines else "" }}],
      )
      // Date range (italic, primary color)
      #text(size: 8.5pt, fill: c-primary, style: "italic")[{{ dal_lines[1] if dal_lines | length > 1 else "" }}]
      #v(0.1cm)
      // Highlights / bullets
      #set text(size: 9pt)
      {% for line in mc_lines[1:] %}
      {{ line }}
      {% endfor %}
    ]
    {% endfor %}

    {% elif section.entry_type == "EducationEntry" %}
    // ── Education entries ─────────────────────────────────────────────────
    {% for entry in section.entries %}
    {% set mc_lines = entry.main_column.splitlines() %}
    {% set dal_lines = entry.date_and_location_column.splitlines() %}
    #block(below: 0.9em)[
      // Header row: institution+area (left) · date range (right)
      #grid(
        columns: (1fr, auto),
        column-gutter: 0.3cm,
        align: (left + top, right + top),
        text(size: 9.5pt)[{{ mc_lines[0] if mc_lines else "" }}],
        text(size: 8pt, style: "italic")[{{ dal_lines[0] if dal_lines else "" }}],
      )
      // Degree (primary color)
      #text(size: 8.5pt, fill: c-primary)[{{ entry.degree_column | default("") }}]
      // Highlights if present
      #set text(size: 9pt)
      {% for line in mc_lines[1:] %}
      {{ line }}
      {% endfor %}
    ]
    {% endfor %}

    {% elif section.entry_type == "OneLineEntry" %}
    // ── One-line entries ──────────────────────────────────────────────────
    #set text(size: 9.5pt)
    {% for entry in section.entries %}
    {{ entry.main_column }}
    #v(0.2em)
    {% endfor %}

    {% elif section.entry_type == "BulletEntry" %}
    // ── Bullet entries ────────────────────────────────────────────────────
    {% for entry in section.entries %}
    - {{ entry.bullet }}
    {% endfor %}

    {% else %}
    // ── Fallback ──────────────────────────────────────────────────────────
    {% for entry in section.entries %}
    {% if entry is string %}
    {{ entry }}
    {% else %}
    {{ entry.main_column }}
    {% endif %}
    {% endfor %}

    {% endif %}
    {% endif %}
    {% endfor %}
  ],
)
