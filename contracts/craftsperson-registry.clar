;; Craftsperson Registry Contract
;; Manages qualified craftsperson profiles and certifications

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u200))
(define-constant ERR-CRAFTSPERSON-NOT-FOUND (err u201))
(define-constant ERR-CRAFTSPERSON-EXISTS (err u202))
(define-constant ERR-INVALID-SKILL-LEVEL (err u203))
(define-constant ERR-CERTIFICATION-EXPIRED (err u204))

;; Data Variables
(define-data-var next-craftsperson-id uint u1)

;; Data Maps
(define-map craftspersons
  { craftsperson-id: uint }
  {
    name: (string-ascii 100),
    contact-info: (string-ascii 200),
    registration-date: uint,
    active-status: bool,
    total-projects: uint,
    average-rating: uint
  }
)

(define-map craftsperson-skills
  { craftsperson-id: uint, skill-name: (string-ascii 50) }
  {
    skill-level: uint,
    certification-date: uint,
    expiry-date: uint,
    certifying-body: (string-ascii 100)
  }
)

(define-map traditional-techniques
  { craftsperson-id: uint, technique: (string-ascii 100) }
  {
    proficiency-level: uint,
    years-experience: uint,
    master-craftsperson: principal,
    documentation: (string-ascii 500)
  }
)

(define-map performance-records
  { craftsperson-id: uint, project-id: uint }
  {
    quality-rating: uint,
    timeliness-rating: uint,
    compliance-rating: uint,
    completion-date: uint
  }
)

(define-map authorized-certifiers
  { certifier: principal }
  { authorized: bool, specialization: (string-ascii 100) }
)

;; Public Functions

;; Register a new craftsperson
(define-public (register-craftsperson
  (name (string-ascii 100))
  (contact-info (string-ascii 200)))
  (let ((craftsperson-id (var-get next-craftsperson-id)))
    (asserts! (is-none (map-get? craftspersons { craftsperson-id: craftsperson-id })) ERR-CRAFTSPERSON-EXISTS)

    (map-set craftspersons
      { craftsperson-id: craftsperson-id }
      {
        name: name,
        contact-info: contact-info,
        registration-date: block-height,
        active-status: true,
        total-projects: u0,
        average-rating: u0
      }
    )

    (var-set next-craftsperson-id (+ craftsperson-id u1))
    (ok craftsperson-id)
  )
)

;; Add skill certification
(define-public (add-skill-certification
  (craftsperson-id uint)
  (skill-name (string-ascii 50))
  (skill-level uint)
  (certifying-body (string-ascii 100))
  (validity-period uint))
  (let ((craftsperson (unwrap! (map-get? craftspersons { craftsperson-id: craftsperson-id }) ERR-CRAFTSPERSON-NOT-FOUND)))
    (asserts! (< skill-level u6) ERR-INVALID-SKILL-LEVEL)
    (asserts! (or (is-eq tx-sender CONTRACT-OWNER)
                  (default-to false (get authorized (map-get? authorized-certifiers { certifier: tx-sender })))) ERR-NOT-AUTHORIZED)

    (map-set craftsperson-skills
      { craftsperson-id: craftsperson-id, skill-name: skill-name }
      {
        skill-level: skill-level,
        certification-date: block-height,
        expiry-date: (+ block-height validity-period),
        certifying-body: certifying-body
      }
    )
    (ok true)
  )
)

;; Add traditional technique
(define-public (add-traditional-technique
  (craftsperson-id uint)
  (technique (string-ascii 100))
  (proficiency-level uint)
  (years-experience uint)
  (master-craftsperson principal)
  (documentation (string-ascii 500)))
  (let ((craftsperson (unwrap! (map-get? craftspersons { craftsperson-id: craftsperson-id }) ERR-CRAFTSPERSON-NOT-FOUND)))
    (asserts! (< proficiency-level u6) ERR-INVALID-SKILL-LEVEL)

    (map-set traditional-techniques
      { craftsperson-id: craftsperson-id, technique: technique }
      {
        proficiency-level: proficiency-level,
        years-experience: years-experience,
        master-craftsperson: master-craftsperson,
        documentation: documentation
      }
    )
    (ok true)
  )
)

;; Record performance
(define-public (record-performance
  (craftsperson-id uint)
  (project-id uint)
  (quality-rating uint)
  (timeliness-rating uint)
  (compliance-rating uint))
  (let ((craftsperson (unwrap! (map-get? craftspersons { craftsperson-id: craftsperson-id }) ERR-CRAFTSPERSON-NOT-FOUND)))
    (asserts! (and (< quality-rating u6) (< timeliness-rating u6) (< compliance-rating u6)) ERR-INVALID-SKILL-LEVEL)

    (map-set performance-records
      { craftsperson-id: craftsperson-id, project-id: project-id }
      {
        quality-rating: quality-rating,
        timeliness-rating: timeliness-rating,
        compliance-rating: compliance-rating,
        completion-date: block-height
      }
    )

    ;; Update craftsperson statistics
    (let ((updated-projects (+ (get total-projects craftsperson) u1))
          (new-average (/ (+ quality-rating timeliness-rating compliance-rating) u3)))
      (map-set craftspersons
        { craftsperson-id: craftsperson-id }
        (merge craftsperson {
          total-projects: updated-projects,
          average-rating: new-average
        })
      )
    )
    (ok true)
  )
)

;; Authorize certifier
(define-public (authorize-certifier
  (certifier principal)
  (specialization (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set authorized-certifiers
      { certifier: certifier }
      { authorized: true, specialization: specialization }
    )
    (ok true)
  )
)

;; Update craftsperson status
(define-public (update-craftsperson-status
  (craftsperson-id uint)
  (active bool))
  (let ((craftsperson (unwrap! (map-get? craftspersons { craftsperson-id: craftsperson-id }) ERR-CRAFTSPERSON-NOT-FOUND)))
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    (map-set craftspersons
      { craftsperson-id: craftsperson-id }
      (merge craftsperson { active-status: active })
    )
    (ok true)
  )
)

;; Read-only Functions

;; Get craftsperson details
(define-read-only (get-craftsperson (craftsperson-id uint))
  (map-get? craftspersons { craftsperson-id: craftsperson-id })
)

;; Get craftsperson skill
(define-read-only (get-craftsperson-skill (craftsperson-id uint) (skill-name (string-ascii 50)))
  (map-get? craftsperson-skills { craftsperson-id: craftsperson-id, skill-name: skill-name })
)

;; Get traditional technique
(define-read-only (get-traditional-technique (craftsperson-id uint) (technique (string-ascii 100)))
  (map-get? traditional-techniques { craftsperson-id: craftsperson-id, technique: technique })
)

;; Get performance record
(define-read-only (get-performance-record (craftsperson-id uint) (project-id uint))
  (map-get? performance-records { craftsperson-id: craftsperson-id, project-id: project-id })
)

;; Check certification validity
(define-read-only (is-certification-valid (craftsperson-id uint) (skill-name (string-ascii 50)))
  (match (map-get? craftsperson-skills { craftsperson-id: craftsperson-id, skill-name: skill-name })
    skill-data (> (get expiry-date skill-data) block-height)
    false
  )
)

;; Get next craftsperson ID
(define-read-only (get-next-craftsperson-id)
  (var-get next-craftsperson-id)
)
