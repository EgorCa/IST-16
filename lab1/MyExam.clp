

;;****************
;;* DEFFUNCTIONS *
;;****************


(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-haven-auto ""
   (not (haven-auto?))
   (not (repair ?))
   =>
   (assert (haven-auto (yes-or-no-p "Did you have a car earlier(yes/no)? "))))

(defrule determine-like-speed ""
   (not (like-speed?))
   (not (repair ?))
   =>
   (assert (like-speed (yes-or-no-p "Do you like fast drive(yes/no)? "))))

(defrule determine-like-comfort ""
   (not (like-comfort?))
   (not (repair ?))
   =>
   (assert (like-comfort (yes-or-no-p "Do you like a comfort in a car(yes/no)? "))))

(defrule determine-domestic-car ""
   (not (domestic-car?))
   (not (repair ?))
   =>
   (assert (domestic-car (yes-or-no-p "Do you prefer domestic car (yes/no)? "))))


;;;****************
;;;* REPAIR RULES *
;;;****************

(defrule cannotpay ""
   (haven-auto no)
   (like-speed no)
    (not (repair ?))
   =>
   (assert (person-type cannotpay)))

(defrule biker ""
   (haven-auto no)
   (like-speed yes)
    (not (repair ?))
   =>
   (assert (person-type biker)))
	
(defrule canpay ""
   (haven-auto yes)
   (like-speed yes)
    (not (repair ?))
   =>
   (assert (person-type canpay)))

(defrule SUV ""
   (haven-auto yes)
   (like-speed no)
    (not (repair ?))
   =>
   (assert (car-type SUV)))

(defrule Sportcar ""
   (person-type canpay)
   (like-comfort yes)
    (not (repair ?))
   =>
   (assert (car-type Sportcar)))

(defrule Moto ""
   (person-type biker)
   (like-comfort no)
    (not (repair ?))
   =>
   (assert (car-type Moto)))

(defrule Similarcar ""
   (person-type cannotpay)
   (like-comfort no)
    (not (repair ?))
   =>
   (assert (person-type cannotpay)))

(defrule Mercedes ""
   (car-type Sportcar)
   (domestic-car no)
   (not (repair ?))
   =>
   (assert (repair "I offer you Mecedes Benz E63 AMG.")))

(defrule RR ""
   (car-type SUV)
   (like-comfort yes)
   (not (repair ?))
   =>
   (assert (repair "I offer you Range Rover Velar.")))

(defrule Niva ""
   (car-type SUV)
   (domestic-car yes)
   (not (repair ?))
   =>
   (assert (repair "I offer you Lada Niva 4x4.")))

(defrule LadaXRay ""
   (car-type Similarcar)
   (domestic-car yes)
   (not (repair ?))
   =>
   (assert (repair "I offer you the best Lada X-Ray.")))

(defrule GoodBye ""
   (car-type Moto)
   (domestic-car no)
   (not (repair ?))
   =>
   (assert (repair "Sorry, we can't help you.")))

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "The Expert System helping to choose a car")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 10))
  (repair ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Repair:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))

