#Requires AutoHotkey v2.0

; ==============================================================================
; FUNCIÓN DE PEGADO SEGURO Y VELOZ
; ==============================================================================
PegarInstantaneo(texto) {
    Critical                         ; Evita interrupciones durante el proceso
    CopiaPrevia := ClipboardAll()      ; Guarda todo lo que tengas en el portapapeles
    A_Clipboard := ""                ; Limpia el portapapeles
    A_Clipboard := texto             ; Carga el nuevo texto

    if !ClipWait(2) {                ; Espera hasta 2 segundos a que el texto cargue
        return
    }

    Sleep(100)                       ; Pausa técnica para estabilidad
    Send("^v")                       ; Pega el texto (Ctrl + V)
    Sleep(150)                       ; Pausa para asegurar que el pegado terminó
    A_Clipboard := CopiaPrevia        ; Restaura tu portapapeles original
}

; ==============================================================================
; BLOQUE 1: VIAS, HABILITACIONES URBANAS
; ==============================================================================  ;**************  VIA Y HU  ************ 1

;CA LOS PINTORES
:*:+1::010702

;CA ROMULO
:*:+2::020713

;AV LOS HISTORIADORES
:*:+3::010601

;CA EDUARDO NUÑEZ
:*:+4::020715

;CODIGO DE USO
:*:+5::010101
:*:+7::070101


;HABILITACION URBANA
:*:+6::0702

; ==============================================================================
; BLOQUE 2: NOMBRES DE CALLES
; ==============================================================================    ;**************  NOMBRES DE CALLES  ************ 2
:*:+P:: {
    PegarInstantaneo("AVENIDA LOS PINTORES")                                         ;CALLE SLDO FAUSTINO COLAN AVENIDA SLDO JOSE CRUZ GUERRA
}
:*:+O:: {
    PegarInstantaneo("CALLE ROMULO CUNEO VIDAL")
}
:*:+I:: {
    PegarInstantaneo("AVENIDA LOS HISTORIADORES")
}
:*:+Ñ:: {
    PegarInstantaneo("CALLE EDUARDO NUÑEZ NUÑEZ")
}
:*:+L:: {
    PegarInstantaneo("LOTE CATASTRAL 0")
}

; ==============================================================================
; BLOQUE 3: FRASES DE CARACTERISTICAS DE LA TITULARIDAD
; ==============================================================================
:*:-N:: {
    PegarInstantaneo("INSCRIPCION DE HABILITACION URBANA")
}

; ==============================================================================
; BLOQUE 4: AREAS Y MEDIDAS
; ==============================================================================    ;**************  AREAS Y MEDIDAS  ************ 3
:*:*8::120.00
:*:-8::6.00
:*:+8::20.00

; ==============================================================================
; BLOQUE 5: OBSERVACIONES
; ==============================================================================

; VISITA

:*:-M:: {
    Send "SIENDO LAS 00:00 HORAS, NO SE ENCONTRÓ AL TITULAR CATASTRAL EN EL MOMENTO DE LA INSPECCION AL LOTE CATASTRAL"  ;**************  CAMBIAR FRASE, CONTAR RETROCESO DE PALABRAS ** 4

    ; Retrocede 8 palabras (Ctrl + Left)                                ;SIENDO LAS 3:36 HORAS, NO SE ENCONTRÓ AL TITULAR CATASTRAL
    Send "^{Left 17}"                                                    ;LEFT 8
    Send "{Left}"

    ; Selecciona la hora (Shift + Left 5)
    Send "+{Left 5}"
}

; CONTROL DE CALIDAD
:*:*7:: {
    PegarInstantaneo("CONTROL DE CALIDAD :  ARQ. LUCIA VILCA CCALLI")   ;**************  CAMBIAR CONTROL DE CALIDAD  ************ 5
}


; FICHA DE ACTIVIDAD ECONOMICA
; ==============================================================================


; ==============================================================================
; BLOQUE 6: IDENTIFICACION DEL CONDUCTOR
; ==============================================================================
:*:+T:: {
    PegarInstantaneo("TIENDA DE ABARROTES S/N")
}


; ==============================================================================
; BLOQUE 7: OTROS PROVISIONAL
; ==============================================================================
:*:+9::P200594

:*:--::20147797100 ; RUCmpt

;:*:+0:: {
;    PegarInstantaneo("ANTECEDENTE REGISTRAL P200510")
;}
