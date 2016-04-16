(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
                  ;; TODO: Maybe, use this after emacs24 is released
                  ;; (development versions of packages)
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ))
  (add-to-list 'package-archives source t))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes (quote ("da7fa7211dd96fcf77398451e3f43052558f01b20eb8bee9ac0fd88627e11e22" default))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(load-theme 'zenburn t)

;;===============================================================================
;;  Common settings for all languages
;;===============================================================================

;; scrollbar
(scroll-bar-mode -1)
;; toolbar
(tool-bar-mode -1)
;; menu bar
(menu-bar-mode -1)
;; bookmarks
(global-set-key [f7] 'bookmark-set)
(global-set-key [f8] 'bookmark-jump)
;; reverting current buffer
(global-set-key [f5] (lambda ()
                       (interactive)
                       (revert-buffer t t t)
                       (message "buffer is reverted"))) 

;; Scrolling and current line
(setq scroll-step 1)
(global-hl-line-mode 1)

;; full screen
(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                           nil
                                           'fullboth)))
(global-set-key [(meta return)] 'toggle-fullscreen)

;;alt + arrow keys instead of C-x o
(windmove-default-keybindings 'meta)

;; super+alt+arrow keys to change frame borders 
(defun win-resize-top-or-bot () "Figure out if the current window is on top, bottom or in the middle" 
  (let* ((win-edges (window-edges))
         (this-window-y-min (nth 1 win-edges))
         (this-window-y-max (nth 3 win-edges))
         (fr-height (frame-height))
         )
    (cond ((eq 0 this-window-y-min) "top") 
          ((eq (- fr-height 1) this-window-y-max) "bot") 
          (t "mid")))
  )
(defun win-resize-left-or-right () "Figure out if the current window is to the left, right or in the middle" 
  (let* ((win-edges (window-edges)) 
         (this-window-x-min (nth 0 win-edges))
         (this-window-x-max (nth 2 win-edges))
         (fr-width (frame-width))
         ) 
    (cond ((eq 0 this-window-x-min) "left") 
          ((eq (+ fr-width 4) this-window-x-max) "right")
          (t "mid")))
  )
(defun win-resize-enlarge-horiz () (interactive) 
  (cond ((equal "top" (win-resize-top-or-bot)) (enlarge-window -1))
        ((equal "bot" (win-resize-top-or-bot)) (enlarge-window 1))
        ((equal "mid" (win-resize-top-or-bot)) (enlarge-window -1))
        (t (message "nil")))
  )
(defun win-resize-minimize-horiz () (interactive)
  (cond ((equal "top" (win-resize-top-or-bot)) (enlarge-window 1))
        ((equal "bot" (win-resize-top-or-bot)) (enlarge-window -1))
        ((equal "mid" (win-resize-top-or-bot)) (enlarge-window 1))
        (t (message "nil")))
  )
(defun win-resize-enlarge-vert () (interactive)
  (cond ((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally -1))
        ((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally 1))
        ((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally -1)))
  )
(defun win-resize-minimize-vert () (interactive)
  (cond ((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally 1))
        ((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally -1))
        ((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally 1)))
  )

(global-set-key [s-M-down] 'win-resize-mi2nimize-vert)
(global-set-key [s-M-up] 'win-resize-enlarge-vert)
(global-set-key [s-M-left] 'win-resize-minimize-horiz)
(global-set-key [s-M-right] 'win-resize-enlarge-horiz)
(global-set-key [s-M-up] 'win-resize-enlarge-horiz)
(global-set-key [s-M-down] 'win-resize-minimize-horiz)
(global-set-key [s-M-left] 'win-resize-enlarge-vert)
(global-set-key [s-M-right] 'win-resize-minimize-vert) 

;;===============================================================================
;; Settings for C/C++
;;===============================================================================

(require 'cc-mode)
(setq-default c-basic-offset 4 c-default-style "linux" member-init-conf 0)
(setq-default tab-width 4 indent-tabs-mode nil)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; truncate lines, show line numbers, show column number in C/C++
(defun line-column-numbers-mode-common-hook ()
  (linum-mode)
  (column-number-mode)
  (toggle-truncate-lines)
  )
(add-hook 'c-mode-common-hook 'line-column-numbers-mode-common-hook)

;;; yasnippet
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

(add-to-list 'load-path "~/.emacs.d/auto-complete-clang/")
(require 'auto-complete-clang)
(global-set-key (kbd "C-`") 'ac-complete-clang)

(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
              (split-string
               "
 /usr/include/c++/4.8
 /usr/include/c++/4.8.4
 /usr/include/x86_64-linux-gnu/c++/4.8
 /usr/include/c++/4.8/backward
 /usr/include/c++/4.8.4/backward
 /usr/lib/gcc/x86_64-linux-gnu/4.8/include
 /usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed
 /usr/lib/gcc/x86_64-linux-gnu/4.8.4/include
 /usr/lib/gcc/x86_64-linux-gnu/4.8.4/include-fixed
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
"
               )))

(defun my:ac-c-headers-init ()
    (require 'auto-complete-c-headers)
    (add-to-list 'ac-sources 'ac-source-c-headers))

(add-hook 'c++-mode-hook 'my:ac-c-headers-init)
(add-hook 'c-mode-hook 'my:ac-c-headers-init)

;;===============================================================================
;; Settings for common lisp
;;===============================================================================
;; slime can be found in /usr/share/emacs24/site-lisp/slime
;;(add-to-list 'load-path "/usr/share/emacs24/site-lisp/slime/")
;;(require 'slime)
;;(slime-setup '(slime-repl))
;;(setq inferior-lisp-program "/usr/bin/sbcl")
