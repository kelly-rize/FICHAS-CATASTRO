#Requires AutoHotkey v2.0
#SingleInstance Force

#Include utils.ahk
#Include funciones.ahk
#Include clicks.ahk

; ========= CONFIG CODIGO F1 =========
SaltosSector := 7
SaltosManzana := 17
DireccionManzana := "Down"

LoteActual := 0        ; valor lógico
; =========================

; ========= CONFIG UBICACION F2 =========
UltimoCodigoVia := ""
CondicionNumericaSaltos_Default := 2
HabilitacionUrbana := "0702"
EnProceso := false
; ===========================

; ========= CONFIG UBICACION F2 =========
ManzanaNumero := "19"
NroMunicipal := ""
; ===========================

; ========= CONFIG CARACTERISTICAS DE LA TITULARIDAD CUANDO ES MPT MODIFICAR FECHA =========

; ========= CONFIG INSCRIPCION F11 =========
Partida := "P200238"
fp := "24/03/2000"
; ===========================

; ========= CONFIG FIRMAS +F11 Y +F12 =========
DniFirma1 := "00442962"
FechaFirma1 := "29/05/2025"

DniFirma2 := "70612131"
FechaFirma2 := "24/05/2025"
; ===========================

; ========= HOTKEY CODIGO PRINCIPAL =========

F1::
{
    global LoteActual, SaltosLote

    ; A. SECTOR
    SeleccionarCombo(SaltosSector, "Down")
    Send("{Tab 2}")
    Esperar(300, 350)

    ; B. MANZANA
    SeleccionarCombo(SaltosManzana, DireccionManzana)
    Send("{Tab 2}")
    Esperar(300, 350)

    ; C. LOTE (combo consecutivo)
    LoteActual++

    SeleccionarCombo(LoteActual, "Down")
    Send("{Tab}")
    Esperar(300, 500)
    ; LoteActual++

    ; D. CAMPOS FIJOS
    Send("01{Tab}")
    Esperar(120, 200)

    Send("01{Tab}")
    Esperar(120, 200)

    Send("01{Tab}")
    Esperar(120, 200)

    Send("001{Tab}")
    Send("{Enter}")
}

+F1::
{
    global LoteActual
    res := InputBox("¿Desde qué lote iniciar?", "Reset Lote")
    if res.Result != "Cancel" {
        LoteActual := Integer(res.Value) - 1
    }
}

; ========= HOTKEY UBICACIÓN =========
; VERIFICAR ESO DEL ULTIMO CODIGO DE VIA
; VERIFICAR SI LA VIA CORRESPONDE AL SECTOR, VERIFICAR N° DE TABS

F2::
{
    global UltimoCodigoVia, CondicionNumericaSaltos_Default, EnProceso, NroMunicipal

    if EnProceso
        return
    EnProceso := true

    Send("{Tab 2}")
    Send("{Enter}")

    ; --- INPUT ÚNICO ---
    msg :=
        (
            "Formato:"
            "`nCodigoVia|Puerta|NroMunicipal"
            "`nEj: 021213|P|123"
            "`nEj: 021213|S"
        )

    res := InputBox(msg, "Ubicación del Predio")
    if res.Result = "Cancel" {
        EnProceso := false
        return
    }

    partes := StrSplit(res.Value, " ")

    CodigoVia := Trim(partes.Length >= 1 ? partes[1] : "")
    TipoPuerta := StrUpper(Trim(partes.Length >= 2 ? partes[2] : ""))
    NroMunicipal := Trim(partes.Length >= 3 ? partes[3] : "")


    ; --- CÓDIGO DE VÍA ---
    if (CodigoVia != "") {
        UltimoCodigoVia := CodigoVia
        ClickCodigoVia()
        Send(CodigoVia)
        Send("{Enter}")
        Esperar()
        ; --- DECISIÓN HUMANA ---
        ToolTip "Verifica la vía correcta y presiona click para continuar"
        KeyWait "LButton", "D"
        Sleep(150)
        ToolTip ""
        ;Send("{Tab 4}")       ;
        ;Send("{Enter}")
        ;Esperar(600, 900)
    } else if (UltimoCodigoVia = "") {
        MsgBox("No hay código de vía previo.", "Error")
        EnProceso := false
        return
    }

    ; --- FOCO SE PIERDE → CLICK ANCLA ---
    ClickTipoPuerta()

    ; --- TIPO DE PUERTA ---
    ; Ajusta los saltos según tu sistema:
    ; Principal = 1 | Secundaria = 2 | Garage = 3

    ; --- SOLO SI ES PUERTA PRINCIPAL ---
    if (TipoPuerta = "P")
    {
        SeleccionarCombo(4)
        Send("{Tab}")
        Esperar()
        Send(NroMunicipal)
        Esperar()

        Send("{Tab}")
        Esperar()
        SeleccionarCombo(CondicionNumericaSaltos_Default)
        ; --- GUARDAR ---
        Send("{Tab 2}")
        Esperar()
        Send("{Enter}")
    }
    else if (TipoPuerta = "S")
        SeleccionarCombo(5)
    else if (TipoPuerta = "G")
        SeleccionarCombo(3)
    else {
        MsgBox("Tipo de puerta inválido (P/S/G)", "Error")
        EnProceso := false
        return
    }
    ; --- GUARDAR ---
    Send("{Tab 4}")
    Esperar()
    Send("{Enter}")

    EnProceso := false
}

; ;Habilitacion urbana
; +F2::
; {
;     global ManzanaNumero, LoteActual, HabilitacionUrbana

;     ClickHabilitacionUrbana()
;     SendInput(HabilitacionUrbana)
;     Send("{Enter}")
;     Esperar()
;     ; --- DECISIÓN HUMANA ---
;     ToolTip "Verifica la HU y presiona click para continuar"
;     KeyWait "LButton", "D"
;     Sleep(150)
;     ToolTip ""
; }

;Tipo de interior, mz y lt
+F2::
{
    global ManzanaNumero, LoteActual

    SeleccionarCombo(2)
    Send("{Enter}")
    Send("{Tab 4}")
    SendInput(ManzanaNumero)
    Send("{Enter}")
    Send("{Tab}")
    SendInput(LoteActual)
    Send("{Enter}")
    ; --- GUARDAR ---
    Send("{Tab 2}")
    Send("{Enter}")
}

;IDENTIFICADOR DE TITULAR CUANDO ES MPT
;-----------------------------------------------

+F3::
{
    ; A. TIPO DE TITULAR
    SeleccionarCombo(2)
    Send("{Enter}")
    Send("{Tab 16}")
    Esperar()
    Send("{Enter}")
    Esperar()
    SendInput("20147797100")
    Esperar()
    Send("{Enter}")
    Esperar()
    Send("{Tab 5}")
    Esperar()
    Send("{Enter}")
    Esperar()
}

; ========= HOTKEY DOMICILIO FISCAL =========


;DOMICILIO FISCAL CUANDO ES MPT
;--------------------------------

+F4::
{
    ; A. UBICACION
    SeleccionarCombo(3)
    Send("{Tab 4}")
    Esperar()
    Send("{Enter}")
    Send("{Tab 19}")
    Esperar()
    Send("{Enter}")
    Esperar()
}


; +F4::
; {
;     global ManzanaNumero, LoteActual

;     SendInput(ManzanaNumero)
;     Send("{Enter}")
;     Send("{Tab}")
;     SendInput(LoteActual)
;     Send("{Enter}")
;     ; --- GUARDAR ---
;     Send("{Tab 5}")
;     Send("{Enter}")
; }

;========= HOTKEY CARACTERISTICAS DE LA TITULARIDAD =========

F5::
{
    res := InputBox(
        "Formato:`nCT|FA|DD/MM/YYYY`nEj: 1|2|15/08/2019",
        "Características de la Titularidad"
    )

    if res.Result = "Cancel"
        return

    partes := StrSplit(res.Value, " ")

    CondicionTitular := Integer(Trim(partes[1]))
    FormaAdquisicion := Integer(Trim(partes[2]))

    fecha := StrSplit(partes[3], "/")
    Dia := fecha[1]
    Mes := Integer(fecha[2])
    Anio := fecha[3]

    ; A - CONDICIÓN DEL TITULAR
    SeleccionarCombo(CondicionTitular)
    Send("{Tab}")
    Esperar()

    ; B - FORMA DE ADQUISICIÓN
    SeleccionarCombo(FormaAdquisicion)
    Send("{Tab}")
    Esperar()

    ; C - FECHA
    Send(Dia)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(Mes)
    Send("{Tab}")
    Esperar()
    Send(Anio)

    ; --- GUARDAR ---
    Send("{Tab}")
    Send("{Enter}")
}

;CARACTERISTICAS SE LA TITULARIDAD CUANDO ES MPT
;------------------------------------------------
;CAMBIAR FECHA CON LA FICHA

+F5::
{
    SaltosCondicion := 1
    SaltosAdquisicion := 14
    ; A. Condicion
    SeleccionarCombo(SaltosCondicion)
    Send("{Tab}")
    Sleep(300)
    ; B. Adquision
    SeleccionarCombo(SaltosAdquisicion)
    Send("{Tab}")
    SendInput("INDEPENDIZACION (1ERA DOMINIO)")
    Send("{Tab}")
    ; C. FECHA
    SendInput("07")
    Send("{Tab}")
    SeleccionarCombo(3)
    Send("{Tab}")
    SendInput("2008")
    Send("{Tab}")
    Send("{Enter}")
}


;DESCRIPCION DEL PREDIO
F6::
{
    SaltosClasificacion := 2
    SaltosPredio := 8
    ; A. clasificacion
    SeleccionarCombo(SaltosClasificacion)
    Esperar()
    Send("{Tab}")
    Esperar()
    ; B. predio
    SeleccionarCombo(SaltosPredio)
    Send("{Tab}")
    Send("{Enter}")
    Esperar()
    ; c. CODIGO DE USO
    Send("{Tab}")
    Send("{Enter}")
    Esperar()
    ClickCodigoUso()
}

;SERVICIOS
F7::
{
    SaltosServicios := 1
    ; A. LUZ
    Send("{Enter}")
    Send("{Tab}")
    Esperar()
    ; B. AGUA
    Send("{Enter}")
    Send("{Tab}")
    Esperar(100, 300)
    ; C. TELEFONO
    SeleccionarCombo(SaltosServicios, "Down")
    Send("{Tab}")
    Esperar(100, 300)
    ; D. DESAGUE
    Send("{Enter}")
    Send("{Tab}")
    Esperar(100, 300)
    ; E. GAS
    SeleccionarCombo(SaltosServicios, "Down")
    Send("{Tab}")
    Esperar(100, 300)
    ; F. INTERNET
    SeleccionarCombo(SaltosServicios, "Down")
    Send("{Tab}")
    Esperar(100, 300)
    ; G. CABLE
    SeleccionarCombo(SaltosServicios, "Down")
    Send("{Tab}")
    Send("{Enter}")
    Esperar(100, 300)
}


; ========= HOTKEY CONSTRUCCIONES =========

F8::
{
    msg :=
        (
            "Formato:"
            "`nPISO|MM/YYYY|ME|EC|ET|MC|T|P|PV|R|B|I|AREA"
            "`nEj: 1|05/2018|2|3|2|A|B|C|B|A|B|C|85"
        )

    res := InputBox(msg, "CONSTRUCCIONES")
    if res.Result = "Cancel"
        return

    p := StrSplit(res.Value, " ")
    if p.Length < 13 {
        MsgBox("Formato incompleto.", "Error")
        return
    }

    Piso := Trim(p[1])

    fecha := StrSplit(p[2], "/")
    Mes := Integer(fecha[1])
    Anio := fecha[2]

    ME := Integer(p[3]) + 1
    EC := Integer(p[4]) + 1
    ET := Integer(p[5]) + 1

    MC := LetraASaltos(p[6])
    T := LetraASaltos(p[7])
    Pz := LetraASaltos(p[8])
    PV := LetraASaltos(p[9])
    R := LetraASaltos(p[10])
    B := LetraASaltos(p[11])
    I := LetraASaltos(p[12])

    Area := Trim(p[13])

    ; === 56 - N° PISO ===
    Send(Piso)
    Send("{Tab}")
    Esperar()

    ; === 57 - FECHA CONSTRUCCIÓN ===
    SeleccionarCombo(Mes)
    Send("{Tab}")
    Esperar()
    Send(Anio)
    Send("{Tab}")
    Esperar()

    ; === 58 / 59 / 60 ===
    SeleccionarCombo(ME)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(EC)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(ET)
    Send("{Tab}")
    Esperar()

    ; === 61 → 67 (LETRAS) ===
    SeleccionarCombo(MC)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(T)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(Pz)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(PV)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(R)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(B)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(I)
    Send("{Tab}")
    Esperar()

    ; === 68 - ÁREA VERIFICADA ===
    Send(Area)

    ; --- DECISIÓN HUMANA ---
    ToolTip "Verifica los datos y guarda manualmente"
    Sleep(2000)
    ToolTip ""
    ; ----- GUARDAR -----
    Send("{Tab 3}")
}
; =============================

; ========= HOTKEY OBRAS COMPLEMENTARIAS =========

F9::
{
    msg :=
        (
            "Formato:"
            "`nMM/YYYY|MEP|ECS|ECC|PRO"
            "`nEj:05/2018|2|3|2|85"
        )

    res := InputBox(msg, "OBRAS COMPLEMENTARIAS")
    if res.Result = "Cancel"
        return

    p := StrSplit(res.Value, " ")
    if p.Length < 5 {
        MsgBox("Formato incompleto.", "Error")
        return
    }

    fecha := StrSplit(p[1], "/")
    Mes := Integer(fecha[1])
    Anio := fecha[2]

    MEP := Integer(p[2]) + 1
    ECS := Integer(p[3]) + 1
    ECC := Integer(p[4]) + 1

    ; MC := LetraASaltos(p[6])
    ; T := LetraASaltos(p[7])
    ; Pz := LetraASaltos(p[8])
    ; PV := LetraASaltos(p[9])
    ; R := LetraASaltos(p[10])
    ; B := LetraASaltos(p[11])
    ; I := LetraASaltos(p[12])

    Area := Trim(p[5])

    ; === 57 - FECHA  DE CONSTRUCCION ===
    SeleccionarCombo(Mes)
    Send("{Tab}")
    Esperar()
    Send(Anio)
    Send("{Tab}")
    Esperar()

    ; === 58 MEP / 59 ECS / 60 ECC ===
    SeleccionarCombo(MEP)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(ECS)
    Send("{Tab}")
    Esperar()

    SeleccionarCombo(ECC)
    Send("{Tab}")
    Esperar()
    ; === 68 - PRODUCTO TOTAL===
    Send(Area)

    ; --- DECISIÓN HUMANA ---
    ToolTip "Verifica los datos y guarda manualmente"
    Sleep(2000)
    ToolTip ""
    ; ----- GUARDAR -----
    Send("{Tab 4}")
}
; =============================

;INSCRIPCION DEL PREDIO

F11::
{
    global partida, fp

    SaltosTipoPartida := 4
    ; C. Tipo Partida
    SeleccionarCombo(SaltosTipoPartida, "Down")
    Send("{Tab}")
    Sleep(400)
    ; C. numero
    SendInput(Partida)
    Send("{Tab 2}")
    SendInput("00001")
    Send("{Tab}")
    SendInput(fP)
    Send("{Enter}")
    Send("{Tab 5}")
    Send("{Enter}")
    Esperar()
}


;FIRMA 1 (SUPERVISOR)
+F11::
{
    global DniFirma1, FechaFirma1

    Send("{Tab 3}")
    Esperar()
    Send("{Enter}")
    SendInput(DniFirma1)
    Send("{Enter}")
    Esperar()
    Send("{Enter}")
    Esperar()
    Send("{Tab 5}")
    Send("{Enter}")

    ClickFirma1()

    SendInput(FechaFirma1)
    Send("{Enter}")
    Esperar()
    Send("{Tab 3}")
    Esperar()
    Send("{Enter}")

}

;ClickFirma2_I()

;FIRMA 1 (SUPERVISOR)
+F12::
{
    global DniFirma1, FechaFirma1

    Send("{Tab 3}")
    Esperar()
    Send("{Enter}")
    SendInput(DniFirma2)
    Send("{Enter}")
    Esperar(200, 400)
    Send("{Enter}")
    Esperar()
    Send("{Tab 5}")
    Send("{Enter}")

    ClickFirma2()

    SendInput(FechaFirma2)
    Send("{Enter}")
    Esperar()
    Send("{Tab 3}")
    Send("{Enter}")

}

; ===========================

; ============================
; FICHA DE COTITULARIDAD
; ============================

^F1::
{
    global ManzanaNumero, NroMunicipal, LoteActual

    msg :=
        (
            "Formato:"
            "`nPorcentaje_Cotitularidad|Form_Adq|Fecha_Adq"
            "`nEj: 50|1|12/2003"
        )

    res := InputBox(msg, "Ficha de Cotitularidad")
    if res.Result = "Cancel" {
        EnProceso := false
        return
    }

    p := StrSplit(res.Value, " ")

    if p.Length < 3 {
        MsgBox("Formato incompleto.", "Error")
        return
    }

    Porcentaje_Cotitularidad := Trim(p[1])
    Form_Adq := Integer(p[2]) + 1
    Fecha_Adq := Trim(p[3])

    ;Porcentaje de cotitularidad
    Send(Porcentaje_Cotitularidad)
    Send("{Tab 2}")
    Esperar()

    ; Forma de adquisicion
    SeleccionarCombo(Form_Adq)
    Send("{Enter}")
    Send("{Tab}")
    Esperar()

    ; Fecha de adquisicion
    Send(Fecha_Adq)
    Send("{Enter}")
    Send("{Tab 6}")
    Esperar()

    ;Provincia
    SeleccionarCombo(1)
    Send("{Enter}")
    Send("{Tab}")
    Esperar()

    ;Distrito
    SeleccionarCombo(2, "Up")
    Send("{Enter}")
    Send("{Tab 5}")
    Esperar()

    ; N° Municipal
    Send(NroMunicipal)
    Send("{Enter}")
    Send("{Tab 8}")
    Esperar()

    ; Manzana
    Send(ManzanaNumero)
    Send("{Enter}")
    Send("{Tab}")
    Esperar()

    ;Lote
    Send(LoteActual)
    Send("{Enter}")
    Esperar()

}