;;; cl-pdf copyright 2002-2005 Marc Battyani see license.txt for the details
;;; You can reach me at marc.battyani@fractalconcept.com or marc@battyani.net
;;; The homepage of cl-pdf is here: http://www.fractalconcept.com/asp/html/cl-pdf.html

(in-package #:pdf)

;;; This file contains some special variables which need to be set
;;; depending on your Lisp implementation/OS/installation.

(defconstant +external-format+
  #-(or sbcl lispworks clisp allegro) :default
  #+sbcl :latin-1
  #+(and allegro mswindows) :octets
  #+(and allegro unix) :default
  #+lispworks '(:latin-1 :eol-style :lf)
  #+clisp :unix)

#+clisp
(setf *default-file-encoding*  (ext:make-encoding :charset charset:iso-8859-1))

;; Map exceptional but useful characters to the [0-255] range for a single-byte encoding
;; Add more here...
(defparameter *char-single-byte-codes*
 '((#.(code-char #x2013) . #x96)	; En dash: 8211 -> 150
   (#.(code-char #x2014) . #x97)	; Em dash: 8212 -> 151
   (#.(code-char #x2022) . #xB7)	; Bullet: 8226 -> 183
   (#.(code-char #x2026) . #x85)	; Ellipsis: 8230 -> 133
   (#.(code-char #x2039) . #x8B)	; Single left angle quotation mark: 8249 -> 139
   (#.(code-char #x203A) . #x9B)	; Single right angle quotation mark: 8250 -> 155
   (#.(code-char #x2122) . #x99)	; Trademark: 8482 -> 153
) )

;; Charset for strings mentioned outside content streams, e.g. in outlines.
;; See #<method write-object (string &optional root-level)>
(defvar *default-charset*
  #+(and lispworks win32) (ef::ef-coded-character-set win32:*multibyte-code-page-ef*)
  #-(and lispworks win32) *char-single-byte-codes*)	; last resort

(defvar *min-size-for-compression* 300)

(defvar *compress-streams* nil
  "Enables the internal streams compression by zlib")

(defvar *embed-fonts* :default
  "t, nil, or :default (let make-font-dictionary and font-descriptor decide for themselves)")

(defvar *compress-fonts* t "nil or decode filter designator")

;; The *afm-files-directories* is only for the 14 predefined fonts.
;; other fonts must have their afm files read only when they are loaded
;; Rationale for redefinition:
;;  Neither of the versions of search-for-file can search the original value of
;;  *afm-files-directories* (#P"cl-pdf/afm/*.afm") as it contains wildcards!
(defparameter *afm-files-directories*
  (list #p"/usr/share/fonts/afm/"
        (merge-pathnames "afm/" (directory-namestring (asdf:component-pathname (asdf:find-system :cl-pdf)))))
  "The list of directories containing the Adobe Font Metrics and other font files.
 Can be expanded by additionally loaded modules.")


;; define the :pdf-binary feature if your Lisp implementation accepts
;; to write binary sequences to character streams
;; For LW you need version 4.2.7 minimum
#+(or lispworks allegro sbcl)
(pushnew :pdf-binary *features*)

;a catchall for various kind of errors that can happen in the generation of a document.
; just catch 'max-number-of-pages-reached if you want to do something with this.
(defvar *max-number-of-pages* 1000
  "The maximum number of pages for a document")

(defvar *a4-portrait-page-bounds* #(0 0 595 841))
(defvar *letter-portrait-page-bounds* #(0 0 612 792))
(defvar *a4-landscape-page-bounds* #(0 0 841 595))
(defvar *letter-landscape-page-bounds* #(0 0 792 612))
(defvar *default-page-bounds* *a4-portrait-page-bounds*)
