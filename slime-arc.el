;;; slime-arc.el --- SLIME adapter for Arc

;; Copyright (C) 2010 Takeshi Banse <takebi@laafc.net>
;; Author: Takeshi Banse <takebi@laafc.net>
;; Keywords: slime, language, arc

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; This file contains SLIME adapter code for programming in Arc.

;;; Installation:
;;
;; 1. You need Arc (anarki version)
;;    and set the `slime-arc-arc-path' pointing to its source directory.
;; 2. Set the `slime-arc-path' pointing to the directory consisting this
;;    "swank-arc.el" file itself and add to the `load-path'.
;; 3. Set up the SLIME properly.
;;    Call `slime-setup' and include 'slime-arc as the arguments:
;;      (slime-setup '([otheres contribs ...] slime-arc))
;;    or simply require slime-arc in some appropriate manner.

;;; Commands:
;;
;; Below are complete command list:
;;
;;  `slime-arc'
;;    Start an Arc process and connect to its Swank server within a preconfigured environment.
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;
;;  `slime-arc-port'
;;    *Port to use for the Arc Swank server to listen.
;;    default = slime-port
;;  `slime-arc-path'
;;    *Root directory of the swank-arc in which this file itself consists.
;;    default = (expand-file-name "~/c/experiment/swank-arc/")
;;  `slime-arc-arc-path'
;;    *Root directory of the Arc source distribution.
;;    default = (expand-file-name "~/c/arc/arc/")

;;; Code:

(defgroup slime-arc nil
  "Arc server configuration."
  :prefix "slime-arc-"
  :group 'slime-arc)

(defcustom slime-arc-port slime-port
  "*Port to use for the Arc Swank server to listen."
  :type 'integer
  :group 'slime-arc)

(defcustom slime-arc-path (expand-file-name "~/c/experiment/swank-arc/")
  "*Root directory of the swank-arc in which this file itself consists."
  :type 'directory
  :group 'slime-arc)

(defcustom slime-arc-arc-path (expand-file-name "~/c/arc/arc/")
  "*Root directory of the Arc source distribution."
  :type 'directory
  :group 'slime-arc)

(defun slime-arc-init-command (port-filename _coding-system)
  (funcall
   (lambda (xs) (concat (mapconcat 'prin1-to-string xs "\n") "\n\n"))
   `(($:require (file ,(concat slime-arc-path "getpid.ss")))
     (load ,(concat slime-arc-path "swank.arc"))
     (swank-beforeinit ,slime-protocol-version)
     (swank-server ,slime-arc-port ,port-filename))))

(defun slime-arc ()
  "Start an Arc process and connect to its Swank server within a preconfigured environment."
  (interactive)
  (let ((slime-lisp-implementations
         '((arc ("arc") :init slime-arc-init-command)))
        (default-directory slime-arc-arc-path))
    (slime 'arc)))

(defun slime-arc-mode-hook ()
  (slime-mode 1)
  ;; flickers the modeline a lot, so disable for now.
  (when (fboundp 'slime-autodoc-mode) (funcall 'slime-autodoc-mode -1)))

(defun slime-arc-init ()
  (add-hook 'arc-mode-hook 'slime-arc-mode-hook))

(defun slime-arc-unload ()
  (remove-hook 'arc-mode-hook 'slime-arc-mode-hook))

(provide 'slime-arc)
;;; slime-arc.el ends here
