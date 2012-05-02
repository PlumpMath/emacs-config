(add-to-list 'load-path (concat thirdparty-dir "popwin-el/"))
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(global-set-key (kbd "C-x p") popwin:keymap)

(setq popwin:special-display-config
      '(("*Help*" :stick t)
        ("*Ido Completions*" :noselect t :height 20 :width 30 :position bottom)
        ("*Completions*" :noselect t)
        ("*compilation*" :noselect t)
        ("*Occur*" :noselect t)
        ))
