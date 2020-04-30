(require 'cl)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Originally Created: July  1, 2015
;; 
;; Description: Keep the workspace when closing and openning emacs.
;;              Force load without asking
;; Improvements: 
;; Modified:

(desktop-save-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name:  Auto Refresh files when change
;; Created: Sunday, December 6, 2015
;; Source: Joshua Shelton (http://stackoverflow.com/questions/1480572/how-to-have-emacs-auto-refresh-all-buffers-when-files-have-changed-on-disk)
;; Description:
;; Improvements:
;; Modified:

(global-auto-revert-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name: New Temporary Buffer
;; Created: Monday, December 7, 2015
;; Source: Joshua Shelton
;;         http://stackoverflow.com/questions/10363982/how-can-i-open-a-temporary-buffer
;; Description:
;; Improvements:
;; Modified:



(defun new-scratch ()
  "open up a guaranteed new scratch buffer"
  (interactive)
  (switch-to-buffer (loop for num from 0
                          for name = (format "temp-buffer-%03i" num)
                          while (get-buffer name)
                          finally return name)))

;; Set transparency of emacs
(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name: Joshua
;; Created: 2020-04-25
;; Source: https://github.com/emacs-evil/evil
;; Description: Add Evil mode by default
;; Improvements: 
;; Modified:

;; Enable Evil
;;(require 'evil)
;;(evil-mode 1)

(load-theme 'tango-dark t)

(set-frame-parameter (selected-frame) 'alpha '(85 80))
(add-to-list 'default-frame-alist '(alpha 85 80))
