;; use load-file to reload this file or use C-x C-e at the end of any
;; term to execute

;; there appear to be three package managers: el-get -package-install (list-packages) and elpa

(require 'cl)				; common lisp goodies, loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name:  el-get package initialization
;; Created: July  1, 2015
;; Source: https://github.com/dimitri/el-get
;; Description: Initializes and starts the required pacakges
;; Improvements: 
;; Modified:

(add-to-list 'load-path ".emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path ".emacs.d/el-get-user/recipes")
(el-get 'sync)


;; set local recipes
;; (setq
;;  el-get-sources
;;  '((:name buffer-move			; have to add your own keys
;; 	  :after (progn
;; 		   (global-set-key (kbd "<C-S-up>")     'buf-move-up)
;; 		   (global-set-key (kbd "<C-S-down>")   'buf-move-down)
;; 		   (global-set-key (kbd "<C-S-left>")   'buf-move-left)
;; 		   (global-set-key (kbd "<C-S-right>")  'buf-move-right)))

;;    (:name smex				; a better (ido like) M-x
;; 	  :after (progn
;; 		   (setq smex-save-file "~/.emacs.d/.smex-items")
;; 		   (global-set-key (kbd "M-x") 'smex)
;; 		   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

;;    (:name magit				; git meet emacs, and a binding
;; 	  :after (progn
;; 		   (global-set-key (kbd "C-x C-z") 'magit-status)))

;; (:name goto-last-change		; move pointer back to last change
;; 	  :after (progn
;; 		   ;; when using AZERTY keyboard, consider C-x C-_
;; 		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))))


;; now set our own packages
(setq
 my:el-get-packages
 '(el-get				; el-get is self-hosting
   escreen            			; screen for emacs, C-\ C-h
;;   php-mode-improved			; if you're into php...
   switch-window			; takes over C-x o
   auto-complete			; complete as you type with overlays
;;   yasnippet 				; powerful snippet mode
   zencoding-mode			; http://www.emacswiki.org/emacs/ZenCoding
   color-theme		                ; nice looking emacs
   color-theme-tango	                ; check out color-theme-solarized
   edit-server))

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
(when (ignore-errors (el-get-executable-find "cvs"))
  (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs

(when (ignore-errors (el-get-executable-find "svn"))
  (loop for p in '(psvn    		; M-x svn-status
		   )
	do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)





;;;;;;;;;;;;;;;;;;;;;
;; Name:  Change Styling for Terminal
;; Created: 
;; Source: 
;; Description:  
;; Improvements: 
;; Modified:
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)


;;;;;;;;;;;;;;;;;;;;;
;; Name:  Maximize emacs window
;; Created: 
;; Source: 
;; Description:  
;; Improvements: 
;; Modified:
(defun maximize-window () 
  (interactive)
  (shell-command "sh <<EOF
osascript <<OSA 1> /dev/null 2> /dev/null &
set display_info to (do shell script \"system_profiler -detailLevel mini | grep -a 'Main Display:' -B 4 | grep -a 'Resolution:'\")

set ws to every word of display_info
set wc to the count of ws
set w2 to wc - 2

set screen_height to item wc of ws
set screen_width to item w2 of ws

tell application \"System Events\"
	set frontmostApplication to name of the first process whose frontmost is true
	set frontmostApplication to frontmostApplication as string
	tell process frontmostApplication
		tell window 1
			set position to {0, 20}
			set size to {screen_width, screen_height}
		end tell
	end tell
end tell
OSA
EOF
"))

(global-set-key (kbd "<s-S-return>") 'maximize-window)


;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(custom-safe-themes
;;    (quote
;;     ("4a60f0178f5cfd5eafe73e0fc2699a03da90ddb79ac6dbc73042a591ae216f03" default)))
;;  '(inhibit-startup-screen t)
;;  '(initial-buffer-choice nil)
;;  '(initial-scratch-message nil)
;;  '(package-selected-packages
;;    (quote
;;     (ir-black-theme evil emmet-mode eink-theme auto-complete angular-snippets 2048-game)))
;;  '(send-mail-function (quote sendmail-send-it)))
;; (custom-set-faces

 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;)


;; Added October 20, 2013 by JS
;; This will allow editing in markdown
;; source http://jblevins.org/projects/markdown-mode/
;; git clone git://jblevins.org/git/markdown-mode.git
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;;(load-file "~/.emacs.d/myPackages/markdown-mode.el")
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Added May 30, 2014 by JS
;; This will enable applescript mode
;;(load-file "~/.emacs.d/myPackages/applescript-mode.el")
;;(add-to-list 'auto-mode-alist '("\\.scpt\\'" . applescript-mode))

;; Added October 18, 2013 by JS
;; This will enable the nvALT type behavior in emacs
;; source: http://jblevins.org/projects/deft/
;; git clone git://jblevins.org/git/deft.git
;;(load-file "~/.emacs.d/deft.el")
;;(require 'deft)
;;(setq deft-extension "taskpaper")
;;(setq deft-use-filename-as-title t)
;;(global-set-key [f8] 'deft)

;; Added October 20, 2013 by JS
;; This will customize some of the nvALT features
;; source http://www.pragmaux.com/post/42279375499/nvalt-and-emacs
;;(setq deft-extension "md")
;;(setq deft-directory "~/Development/wikis/Notes.wiki/")
;;(setq deft-text-mode 'markdown-mode)
;;(setq deft-directory "~/Dropbox/TextNotes/")


;; ;;;; Insert-Date
;; ;;;; Added: June 7, 2014
;; ;; Source: http://stackoverflow.com/questions/251908/how-can-i-insert-current-date-and-time-into-a-file-using-emacs

;; ;; ====================
;; ;; insert date and time

;; (defvar current-date-format "%Y-%m-%d"
;;   "Format of date to insert with `insert-current-date' func
;; See help of `format-time-string' for possible replacements")

;; (defvar current-date-time-format "%a %b %d %H:%M:%S %Z %Y"
;;   "Format of date to insert with `insert-current-date-time' func
;; See help of `format-time-string' for possible replacements")

;; (defvar current-time-format "%a %H:%M:%S"
;;   "Format of date to insert with `insert-current-time' func.
;; Note the weekly scope of the command's precision.")

;; (defun insert-current-date ()
;;   "insert the current date and time into current buffer.
;; Uses `current-date-time-format' for the formatting the date/time."
;;        (interactive)
;;        (insert "==========\n")
;; ;       (insert (let () (comment-start)))
;;        (insert (format-time-string current-date-time-format (current-time)))
;;        (insert "\n")
;;        )


;; (defun insert-current-date-time ()
;;   "insert the current date and time into current buffer.
;; Uses `current-date-time-format' for the formatting the date/time."
;;        (interactive)
;;        (insert "==========\n")
;; ;       (insert (let () (comment-start)))
;;        (insert (format-time-string current-date-time-format (current-time)))
;;        (insert "\n")
;;        )

;; (defun insert-current-time ()
;;   "insert the current time (1-week scope) into the current buffer."
;;        (interactive)
;;        (insert (format-time-string current-time-format (current-time)))
;;        (insert "\n")
;;        )

;; (global-set-key "\C-c\C-d" 'insert-current-date-time)
;; (global-set-key "\C-c\C-t" 'insert-current-time)


;; ;;    Keyboard shortcuts:
;; ;;    Ctl-C/Ctl-D     Insert current datetime
;; ;;    Ctl-C/Ctl-t     Insert current time

;; ;;;; End Insert-Date


;;;; Taskpaper
;; Added May 30, 2014 by JS
;; Source: https://github.com/jedthehumanoid/taskpaper.el
;; Simple Taskpaper major mode for emacs.
;; Put taskpaper.el file somewhere (for instance in ~/emacs.d/taskpaper.el)
;; In .emacs, add: 
;;(load-file "~/.emacs.d/myPackages/taskpaper-js.el")

;;(require 'taskpaper-mode)

;; M-x taskpaper-mode to activate, or in .emacs:
;;(add-to-list 'auto-mode-alist '("\\.taskpaper\\'" . taskpaper-mode))
;; for files with .taskpaper extension

;;    Keyboard shortcuts:
;;    S-return     Focus project under cursor
;;    S-backspace  Back to all projects
;;    C-c l        Chose project from list
;;    C-c d        Toggle done state
;;    M-x          taskpaper-mode to activate

;;;; End Taskpaper


;;;;;;;;;;;;;;;;;;;;;
;; Name:  Package Management
;; Created: June 30, 2015
;; Source: http://melpa.milkbox.net/#/getting-started
;;         http://wikemacs.org/wiki/Package.el
;; Description:  
;; Improvements: 
;; Modified:
;;           2015-07-01: added new package repo

(require 'package)
(package-initialize)

(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
;; End: Package Management


;; Load Theme
(load-theme 'ir-black t);; this will make sure that it doesn't ask again
;;(if window-system
;;    (load-file "~/.emacs.d/elpa/ir-black-theme-20130302.2355/ir-black-theme.el"))
;; End Theme


;;;; Marked.app 
;;;; Added May 27, 2015
;;;; Source https://github.com/kotfu/marked-bonus-pack
(defun markdown-preview-file ()
  "use Marked 2 to preview the current file"
  (interactive)
  (shell-command 
   (format "open -a 'Marked 2.app' %s" 
       (shell-quote-argument (buffer-file-name))))
)
(global-set-key "\C-cm" 'markdown-preview-file)

;;;; https://jblevins.org/log/marked-2-command
(setq markdown-open-command "/usr/local/bin/mark")

;; Name: Autocomplete
;; Created: July  1, 2015
;; Source: Joshua Shelton
;; Description: 
;; Improvements: 
;; Modified:

(ac-config-default)
;; end: autocomplete

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name:  Angular.js 
;; Created: July  1, 2015
;; Source: https://github.com/magnars/angular-snippets.el
;;         https://github.com/omouse/angularjs-mode
;; Description: 
;; Improvements: 
;; Modified:

;;(require 'angular-snippets)
;;(add-to-list 'yas-snippet-dirs "~/.emacs.d/angularjs-mode/snippets")
(eval-after-load "sgml-mode"
  '(define-key html-mode-map (kbd "C-c C-d") 'ng-snip-show-docs-at-point))


;;(load-file "~/.emacs.d/angularjs-mode/angular-mode.el")

;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/angularjs-mode/ac-dict")
;;(add-to-list 'ac-modes 'angular-mode)
;;(add-to-list 'ac-modes 'angular-html-mode)

;; End:  Angular.js



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name:  Angular.js 
;; Created: July  1, 2015
;; Source: http://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Emacs-Sessions.html
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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name: Backup to a specific folder
;; Created: Thursday, December 10, 2015
;; Source: http://www.emacswiki.org/emacs/BackupDirectory
;; Description:
;; Improvements:
;; Modified:

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups






(defun cm-reverse-region (&optional arg)
  "Reverse current region, like this: \"a(bc) d\" -> \"d )cb(a\"."
  (interactive "P")
  (let ((reversed (apply 'string (reverse (string-to-list (buffer-substring-no-properties (region-beginning) (region-end)))))))
    (delete-region (region-beginning) (region-end))
    (insert reversed)))




(set-frame-parameter (selected-frame) 'alpha '(85 80))
(add-to-list 'default-frame-alist '(alpha 85 80))


 ;; Set transparency of emacs
 (defun transparency (value)
   "Sets the transparency of the frame window. 0=transparent/100=opaque"
   (interactive "nTransparency Value 0 - 100 opaque:")
   (set-frame-parameter (selected-frame) 'alpha value))

;; Chrome 
(require 'edit-server)
(edit-server-start)



;; ;; installed with el-get-install
;; ;; use with FiraCode
;; ;; source: http://www.modernemacs.com/post/prettify-mode/

;; (require 'pretty-mode)
;; (global-pretty-mode t)


;; ;;;; doesn't work for some reason
;; ;; (pretty-deactivate-groups
;; ;;  '(:equality :ordering :ordering-double :ordering-triple
;; ;;              :arrows :arrows-twoheaded :punctuation
;; ;;              :logic :sets))

;; ;; (pretty-activate-groups
;; ;;  '(:sub-and-superscripts :greek :arithmetic-nary))



;; ;;;;;
;; (global-prettify-symbols-mode 1)

;; (add-hook
;;  'python-mode-hook
;;  (lambda ()
;;    (mapc (lambda (pair) (push pair prettify-symbols-alist))
;;          '(;; Syntax
;;            ("def" .      #x2131)
;;            ("not" .      #x2757)
;;            ("in" .       #x2208)
;;            ("not in" .   #x2209)
;;            ("return" .   #x27fc)
;;            ("yield" .    #x27fb)
;;            ("for" .      #x2200)
;;            ;; Base Types
;;            ("int" .      #x2124)
;;            ("float" .    #x211d)
;;            ("str" .      #x1d54a)
;;            ("True" .     #x1d54b)
;;            ("False" .    #x1d53d)
;;            ;; Mypy
;;            ("Dict" .     #x1d507)
;;            ("List" .     #x2112)
;;            ("Tuple" .    #x2a02)
;;            ("Set" .      #x2126)
;;            ("Iterable" . #x1d50a)
;;            ("Any" .      #x2754)
;;            ("Union" .    #x22c3)))))

;; ;;;

;; (pretty-fonts-set-kwds
;;   '((pretty-fonts-fira-font prog-mode-hook org-mode-hook)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("e1ecb0536abec692b5a5e845067d75273fe36f24d01210bf0aa5842f2a7e029f" "4a60f0178f5cfd5eafe73e0fc2699a03da90ddb79ac6dbc73042a591ae216f03" default)))
 '(package-selected-packages
   (quote
    (doom-themes ir-black-theme evil emmet-mode eink-theme auto-complete angular-snippets 2048-game))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name: Joshua
;; Created: 2020-04-25
;; Source: https://github.com/emacs-evil/evil
;; Description: Add Evil mode by default
;; Improvements: 
;; Modified:

;; Enable Evil
(require 'evil)
(evil-mode 1)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name: Joshua 
;; Created: 2020-04-25
;; Source: https://github.com/raxod502/straight.el
;; Description: Add Strait package management
;; Improvements: 
;; Modified:

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name: Joshua 
;; Created: 2020-04-25
;; Source: https://github.com/hlissner/emacs-doom-themes#install
;; Description: Add Doom Themes
;; Improvements: 
;; Modified:
(straight-use-package 'doom-themes)
(setq doom-theme 'doom-one)

(straight-use-package 'doom-themes
  :config
  ;; global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;  (load-theme 'doom-one t)
;;
;;  ;; enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
;;  
;;  ;; enable custom neotree theme (all-the-icons must be installed!)
;;  (doom-themes-neotree-config)
;;  ;; or for treemacs users
;;  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
;;  (doom-themes-treemacs-config)
;;  
;;  ;; corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
)





