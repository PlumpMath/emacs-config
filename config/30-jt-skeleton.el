;; All languages:
(setq skeleton-pair t)
(global-set-key "(" 'skeleton-pair-insert-maybe)
(global-set-key "[" 'skeleton-pair-insert-maybe)
(global-set-key "{" 'skeleton-pair-insert-maybe)
(global-set-key "\"" 'skeleton-pair-insert-maybe)

;; Just python
(add-hook 'python-mode-hook 
          (lambda () 
            (define-key python-mode-map "'" 'skeleton-pair-insert-maybe)))
