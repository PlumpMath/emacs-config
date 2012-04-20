(defun google ()
  (interactive)
  (helm-c-google-suggest-action (thing-at-point 'symbol)))
(global-set-key (kbd "C-c C-g") 'google)

(defun google-suggest ()
  (interactive)
  (helm :sources 'helm-c-source-google-suggest :buffer "*helm google*" :input (thing-at-point 'symbol)))

(global-set-key (kbd "C-c g") 'google-suggest)
