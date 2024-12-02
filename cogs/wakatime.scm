(require (prefix-in helix.editor. "helix/editor.scm"))
(require (prefix-in helix.misc. "helix/misc.scm"))
(require-builtin "steel/process" as process.)
(require (prefix-in web. "steel-webrequests/webrequests.scm" ))

(provide run-wakatime)

(define wakatime-version "0.1.0")
(define wakatime-agent "helix-wakatime")
(define waka-base-url "https://github.com/wakatime/wakatime-cli/releases/download/v1.106.0")
(define wakatime-time-key "asdasdawaka_")

(define (wakatime-get-current-file)
   (helix.editor.editor-document->path 
     (helix.editor.editor->doc-id
       (helix.editor.editor-focus))))

(define (get-download-url)
  (cond ((string=? (current-os!) "linux")
         (string-append waka-base-url "/wakatime-cli-linux-amd64.zip"))
        ((string=? (current-os!) "macos")
         (string-append waka-base-url "/wakatime-cli-darwin-amd64.zip"))
        ((string=? (current-os!) "windows")
         (string-append waka-base-url "/wakatime-cli-darwin-amd64.zip"))))

(define (home-path-result)
  (if (eq? (current-os!) "windows")
    (maybe-get-env-var "HOMEPATH")
   (maybe-get-env-var "HOME")))

(define (exe-path home)
  (string-append home "/.wakatime/wakatime-cli"))

(define (check-if-downloaded)
  (helix.misc.set-status! "LAMBA LOLO!!!!!!!!!!!!!!!!!")
    (let ([home_dir_valid  (exe-path (Ok->value (home-path-result)))])
      (displayln home_dir_valid)
      ; (if (Ok? (path-exists? home_dir_valid))
      ;     #t
      ;     #f)
      #f
  ))

(define (get-or-create-wakatime-dir)
  (let ([home-dir (Ok->value (home-path-result))])
    (create-directory! (string-append home-dir "/.wakatime"))
    (string-append home-dir "/.wakatime")
    ))

(define (download-and-extract)
 (let* ([req (web.get (get-download-url))]
        [resp (web.call req)]
        [result (web.response->text resp)]
        [file-zip (open-output-file (string-append (get-or-create-wakatime-dir) "/wakatime.zip"))]
        )
   (write-bytes (string->bytes result) file-zip)
   (flush-output-port file-zip)
   (close-output-port file-zip)
     result
   )
 )
    
; (define (wakatime-write cx)
;   (let* ((doc (wakatime-get-current-file))
;          (cmd (process.command "wakatime" (list 
;                 "--entity" doc
;                 "--plugin" 
;                   (string-append wakatime-agent "/" wakatime-version)
;                "--write"
;                 ))))
    
;     (if doc (process.spawn-process cmd) ) ))

(define (wakatime-listen-inserts )
  (register-hook! "post-insert-char" "wakatime-write"))
(wakatime-listen-inserts)

; (define (wakatime-heart-beat)
;   (let ((doc (wakatime-get-current-file)))

;     (if doc (process.spawn-process (process.command wakatime-exe (list 
;                 "--entity" doc
;                 "--plugin" 
;                 (string-append wakatime-agent "/" wakatime-version))))
;         #f))
;   (run-wakatime))

(define (run-wakatime)
  (when (not (check-if-downloaded))
        (helix.misc.set-status! (download-and-extract))))
  ;(helix.misc.enqueue-thread-local-callback-with-delay 1000 wakatime-heart-beat ))
