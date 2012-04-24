(add-to-list 'load-path (concat thirdparty-dir "helm/"))
(require 'helm-config)

(global-set-key (kbd "C-x C-h") 'helm-mini)

(defalias 'regexp 'helm-regexp)
(defalias 'mark-ring 'helm-mark-ring)
(defalias 'kill-ring 'helm-kill-ring)
(defalias 'apropos 'helm-c-apropos)
(defalias 'top 'helm-top)
(defalias 'ucs 'helm-ucs)
(defalias 'colors 'helm-colors)
(defalias 'calculator 'helm-calculator)
