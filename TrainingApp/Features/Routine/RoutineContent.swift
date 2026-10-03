enum RoutineContent {
    static let days: [RoutineDay] = [
        RoutineDay(
            id: "monday", name: "Lunes", title: "Push", subtitle: "Pecho, hombros y tríceps", kind: .strength,
            note: "Cierra con 15–20 min de caminata inclinada a intensidad conversacional.",
            exercises: [
                PrescribedExercise(id: "monday-machine-chest-press", name: "Press de pecho en máquina", prescription: "3 × 8–12", rest: "90–120 s", cue: "RIR 2 · Alternativa: press con mancuernas"),
                PrescribedExercise(id: "monday-machine-incline-press", name: "Press inclinado en máquina", prescription: "3 × 8–12", rest: "90 s", cue: "Escápulas estables"),
                PrescribedExercise(id: "monday-pec-deck-contractor", name: "Pec deck / contractor", prescription: "2 × 12–15", rest: "60–75 s", cue: "Controla el estiramiento"),
                PrescribedExercise(id: "monday-shoulder-press", name: "Shoulder press", prescription: "3 × 8–12", rest: "90 s", cue: "No arquees la espalda"),
                PrescribedExercise(id: "monday-cable-or-machine-lateral-raise", name: "Elevación lateral en polea o máquina", prescription: "3 × 12–20", rest: "60 s", cue: "Movimiento limpio"),
                PrescribedExercise(id: "monday-rope-triceps", name: "Tríceps con cuerda", prescription: "3 × 10–15", rest: "60–75 s", cue: "Codos fijos"),
            ],
            recoveryItems: []
        ),
        RoutineDay(
            id: "tuesday", name: "Martes", title: "Pull", subtitle: "Espalda, bíceps y deltoide posterior", kind: .strength,
            note: nil,
            exercises: [
                PrescribedExercise(id: "tuesday-lat-pulldown", name: "Jalón al pecho", prescription: "3 × 8–12", rest: "90 s", cue: "Codos hacia abajo"),
                PrescribedExercise(id: "tuesday-seated-cable-row", name: "Remo sentado en cable", prescription: "3 × 8–12", rest: "90 s", cue: "Sin balancear el torso"),
                PrescribedExercise(id: "tuesday-converging-hammer-row", name: "Remo convergente / Hammer", prescription: "3 × 10–12", rest: "90 s", cue: "Pausa al final"),
                PrescribedExercise(id: "tuesday-cable-pullover", name: "Pullover en polea", prescription: "2 × 12–15", rest: "60–75 s", cue: "Brazos casi extendidos"),
                PrescribedExercise(id: "tuesday-face-pull", name: "Face pull", prescription: "3 × 12–20", rest: "60 s", cue: "Hombros lejos de las orejas"),
                PrescribedExercise(id: "tuesday-scott-or-machine-curl", name: "Curl Scott o máquina", prescription: "3 × 10–15", rest: "60–75 s", cue: "Sin impulso"),
            ],
            recoveryItems: []
        ),
        RoutineDay(
            id: "wednesday", name: "Miércoles", title: "Recuperación", subtitle: "Descanso y movilidad opcional", kind: .recovery,
            note: nil, exercises: [],
            recoveryItems: [
                RecoveryItem(id: "wednesday-gentle-walk", name: "Caminata suave", target: "15–30 min", reference: "Ritmo cómodo", cue: "Opcional"),
                RecoveryItem(id: "wednesday-general-mobility", name: "Movilidad general", target: "8–12 min", reference: "Sin dolor", cue: "Opcional"),
                RecoveryItem(id: "wednesday-sleep-hydration", name: "Sueño e hidratación", target: "7–9 h", reference: "3.0–3.7 L", cue: "Prioridad"),
            ]
        ),
        RoutineDay(
            id: "thursday", name: "Jueves", title: "Pierna A", subtitle: "Cuádriceps, femoral, glúteo y pantorrilla", kind: .strength,
            note: nil,
            exercises: [
                PrescribedExercise(id: "thursday-incline-leg-press", name: "Prensa inclinada", prescription: "4 × 8–12", rest: "120 s", cue: "Rodillas alineadas"),
                PrescribedExercise(id: "thursday-hack-squat-guided-squat", name: "Hack squat o sentadilla guiada", prescription: "3 × 8–12", rest: "120 s", cue: "Rango sin dolor"),
                PrescribedExercise(id: "thursday-seated-or-lying-leg-curl", name: "Curl femoral sentado o acostado", prescription: "3 × 10–15", rest: "75–90 s", cue: "Control excéntrico"),
                PrescribedExercise(id: "thursday-leg-extension", name: "Extensión de cuádriceps", prescription: "2 × 12–15", rest: "60–75 s", cue: "Pausa arriba"),
                PrescribedExercise(id: "thursday-machine-hip-thrust", name: "Hip thrust en máquina", prescription: "3 × 8–12", rest: "90 s", cue: "No hiperextiendas la espalda"),
                PrescribedExercise(id: "thursday-machine-calf-raise", name: "Gemelos en máquina", prescription: "4 × 10–15", rest: "60 s", cue: "Recorrido completo"),
            ],
            recoveryItems: []
        ),
        RoutineDay(
            id: "friday", name: "Viernes", title: "Descanso completo", subtitle: "Sueño, alimentación y preparación", kind: .rest,
            note: nil, exercises: [],
            recoveryItems: [
                RecoveryItem(id: "friday-strength-rest", name: "Descanso de fuerza", target: "Todo el día", reference: "Sin sesión", cue: "Prioridad"),
                RecoveryItem(id: "friday-session-preparation", name: "Preparar la sesión", target: "5–10 min", reference: "Revisar cargas", cue: "Sábado"),
                RecoveryItem(id: "friday-sleep-hydration", name: "Sueño e hidratación", target: "7–9 h", reference: "3.0–3.7 L", cue: "Prioridad"),
            ]
        ),
        RoutineDay(
            id: "saturday", name: "Sábado", title: "Upper completo", subtitle: "Hipertrofia de tren superior", kind: .strength,
            note: nil,
            exercises: [
                PrescribedExercise(id: "saturday-dumbbell-or-machine-incline-press", name: "Press inclinado con mancuernas o máquina", prescription: "3 × 8–12", rest: "90 s", cue: "Pecho superior"),
                PrescribedExercise(id: "saturday-neutral-grip-pulldown", name: "Jalón neutro", prescription: "3 × 8–12", rest: "90 s", cue: "Control total"),
                PrescribedExercise(id: "saturday-chest-supported-row", name: "Remo pecho apoyado", prescription: "3 × 10–12", rest: "90 s", cue: "Sin balanceo"),
                PrescribedExercise(id: "saturday-lateral-raise", name: "Elevación lateral", prescription: "3 × 12–20", rest: "60 s", cue: "Sin encoger hombros"),
                PrescribedExercise(id: "saturday-cable-triceps", name: "Tríceps en polea", prescription: "2 × 10–15", rest: "60 s", cue: "RIR 1–2"),
                PrescribedExercise(id: "saturday-cable-curl", name: "Curl en polea", prescription: "2 × 10–15", rest: "60 s", cue: "RIR 1–2"),
            ],
            recoveryItems: []
        ),
        RoutineDay(
            id: "sunday", name: "Domingo", title: "Lower B + Core", subtitle: "Cadena posterior, abdomen y cardio", kind: .strength,
            note: "Cardio zona 2: 25–35 min. Debes poder hablar en frases cortas sin jadear.",
            exercises: [
                PrescribedExercise(id: "sunday-dumbbell-romanian-deadlift", name: "Peso muerto rumano con mancuernas", prescription: "3 × 8–12", rest: "120 s", cue: "Cadera hacia atrás"),
                PrescribedExercise(id: "sunday-leg-curl", name: "Curl femoral", prescription: "3 × 10–15", rest: "75–90 s", cue: "Controla el regreso"),
                PrescribedExercise(id: "sunday-comfortable-stance-leg-press", name: "Prensa, postura cómoda", prescription: "3 × 10–15", rest: "90 s", cue: "No bloquees rodillas"),
                PrescribedExercise(id: "sunday-machine-abductors", name: "Abductores en máquina", prescription: "3 × 15–20", rest: "60 s", cue: "Pausa exterior"),
                PrescribedExercise(id: "sunday-machine-or-cable-crunch", name: "Crunch en máquina o polea", prescription: "3 × 10–15", rest: "60 s", cue: "Flexiona el tronco"),
                PrescribedExercise(id: "sunday-plank", name: "Plancha", prescription: "3 × 25–45 s", rest: "60 s", cue: "Respira y mantén postura"),
            ],
            recoveryItems: []
        ),
    ]
}
