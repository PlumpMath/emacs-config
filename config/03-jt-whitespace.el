;; show whitespace in red
(require 'whitespace)
(setq whitespace-style
      '(face empty space-before-tab space-after-tab trailing))
(global-whitespace-mode)
