(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?inital - location ?target - location ?roboto - robot)
      :precondition (and 
                        (connected ?inital ?target)
                        (at ?roboto ?inital)
                        (no-robot ?target)
                        (free ?roboto)
                    )
      :effect (and
                (at ?roboto ?target)
                (not (at ?roboto ?inital))
                (no-robot ?inital)
                (not (no-robot ?target))
            )
   )
   
    (:action robotMoveWithPallette
      :parameters (?inital - location ?target - location ?roboto - robot ?pal - pallette)
      :precondition (and 
                        (connected ?inital ?target)
                        (at ?roboto ?inital)
                        (at ?pal ?inital)
                        (no-robot ?target)
                        (no-pallette ?target)
                    )
      :effect (and
                (not (at ?roboto ?inital))
                (not (at ?pal ?inital))
                (at ?roboto ?target)
                (at ?pal ?target)
                (not (no-robot ?target))
                (not (no-pallette ?target))
                (no-robot ?inital)
                (no-pallette ?inital)
            )
   )
   
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?pal - pallette ?o - order)
      :precondition (and 
                        (packing-location ?l)
                        ; (not(available ?l))
                        (packing-at ?s ?l)
                        (at ?pal ?l)
                        (contains ?pal ?si)
                        
                        (orders ?o ?si)
                        (started ?s)
                        (not(unstarted ?s))
                        (ships ?s ?o)
                    )
      :effect (and
                (includes ?s ?si)
                (not (contains ?pal ?si))

            )
    )
    
    (:action completeShipment
      :parameters (?l - location ?s - shipment ?o - order)
      :precondition (and 
                        (packing-location ?l)
                        (packing-at ?s ?l)
                        ; (not(available ?l))
                        
                        (started ?s)
                        ; (not(unstarted ?s)) 
                        (not (complete ?s))
                        (ships ?s ?o)
                    )
      :effect (and
                (complete ?s)
                (available ?l)

            )
    
    )
   
)


