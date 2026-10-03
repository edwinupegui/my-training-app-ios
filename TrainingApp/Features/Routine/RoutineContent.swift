enum RoutineContent {
    static let days: [RoutineDay] = [
        RoutineDay(
            id: "monday", name: "Lunes", title: "Push", subtitle: "Pecho, hombros y tríceps", kind: .strength,
            note: "Cierra con 15–20 min de caminata inclinada a intensidad conversacional.",
            exercises: [
                PrescribedExercise(id: "monday-machine-chest-press", name: "Press de pecho en máquina", prescription: "3 × 8–12", rest: "90–120 s", cue: "RIR 2 · Alternativa: press con mancuernas", guideReferences: [reference("monday-machine-chest-press-machine", "Press en máquina", "monday-machine-chest-press"), reference("monday-machine-chest-press-dumbbell", "Press con mancuernas", "monday-dumbbell-chest-press")]),
                PrescribedExercise(id: "monday-machine-incline-press", name: "Press inclinado en máquina", prescription: "3 × 8–12", rest: "90 s", cue: "Escápulas estables", guideReferences: [reference("monday-machine-incline-press-machine", "Press inclinado en máquina", "monday-machine-incline-press")]),
                PrescribedExercise(id: "monday-pec-deck-contractor", name: "Pec deck / contractor", prescription: "2 × 12–15", rest: "60–75 s", cue: "Controla el estiramiento", guideReferences: [reference("monday-pec-deck-guide", "Pec deck", "monday-pec-deck")]),
                PrescribedExercise(id: "monday-shoulder-press", name: "Shoulder press", prescription: "3 × 8–12", rest: "90 s", cue: "No arquees la espalda", guideReferences: [reference("monday-shoulder-press-guide", "Press de hombros", "monday-shoulder-press")]),
                PrescribedExercise(id: "monday-cable-or-machine-lateral-raise", name: "Elevación lateral en polea o máquina", prescription: "3 × 12–20", rest: "60 s", cue: "Movimiento limpio", guideReferences: [reference("monday-lateral-raise-cable", "Elevación lateral en polea", "monday-cable-lateral-raise"), reference("monday-lateral-raise-machine", "Elevación lateral en máquina", "monday-machine-lateral-raise")]),
                PrescribedExercise(id: "monday-rope-triceps", name: "Tríceps con cuerda", prescription: "3 × 10–15", rest: "60–75 s", cue: "Codos fijos", guideReferences: [reference("monday-rope-triceps-guide", "Tríceps con cuerda", "monday-rope-triceps")]),
            ],
            recoveryItems: []
        ),
        RoutineDay(
            id: "tuesday", name: "Martes", title: "Pull", subtitle: "Espalda, bíceps y deltoide posterior", kind: .strength,
            note: nil,
            exercises: [
                PrescribedExercise(id: "tuesday-lat-pulldown", name: "Jalón al pecho", prescription: "3 × 8–12", rest: "90 s", cue: "Codos hacia abajo", guideReferences: [reference("tuesday-lat-pulldown-guide", "Jalón al pecho", "tuesday-lat-pulldown")]),
                PrescribedExercise(id: "tuesday-seated-cable-row", name: "Remo sentado en cable", prescription: "3 × 8–12", rest: "90 s", cue: "Sin balancear el torso", guideReferences: [reference("tuesday-seated-cable-row-guide", "Remo sentado en cable", "tuesday-seated-cable-row")]),
                PrescribedExercise(id: "tuesday-converging-hammer-row", name: "Remo convergente / Hammer", prescription: "3 × 10–12", rest: "90 s", cue: "Pausa al final", guideReferences: [reference("tuesday-converging-row-guide", "Remo convergente", "tuesday-converging-row")]),
                PrescribedExercise(id: "tuesday-cable-pullover", name: "Pullover en polea", prescription: "2 × 12–15", rest: "60–75 s", cue: "Brazos casi extendidos", guideReferences: [reference("tuesday-cable-pullover-guide", "Pullover en polea", "tuesday-cable-pullover")]),
                PrescribedExercise(id: "tuesday-face-pull", name: "Face pull", prescription: "3 × 12–20", rest: "60 s", cue: "Hombros lejos de las orejas", guideReferences: [reference("tuesday-face-pull-guide", "Face pull", "tuesday-face-pull")]),
                PrescribedExercise(id: "tuesday-scott-or-machine-curl", name: "Curl Scott o máquina", prescription: "3 × 10–15", rest: "60–75 s", cue: "Sin impulso", guideReferences: [reference("tuesday-curl-scott", "Curl Scott", "tuesday-scott-curl"), reference("tuesday-curl-machine", "Curl en máquina", "tuesday-machine-curl")]),
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
                PrescribedExercise(id: "thursday-incline-leg-press", name: "Prensa inclinada", prescription: "4 × 8–12", rest: "120 s", cue: "Rodillas alineadas", guideReferences: [reference("thursday-incline-leg-press-guide", "Prensa inclinada", "thursday-incline-leg-press")]),
                PrescribedExercise(id: "thursday-hack-squat-guided-squat", name: "Hack squat o sentadilla guiada", prescription: "3 × 8–12", rest: "120 s", cue: "Rango sin dolor", guideReferences: [reference("thursday-squat-hack", "Hack squat", "thursday-hack-squat"), reference("thursday-squat-guided", "Sentadilla guiada", "thursday-guided-squat")]),
                PrescribedExercise(id: "thursday-seated-or-lying-leg-curl", name: "Curl femoral sentado o acostado", prescription: "3 × 10–15", rest: "75–90 s", cue: "Control excéntrico", guideReferences: [reference("thursday-leg-curl-seated", "Curl femoral sentado", "thursday-seated-leg-curl"), reference("thursday-leg-curl-lying", "Curl femoral acostado", "thursday-lying-leg-curl")]),
                PrescribedExercise(id: "thursday-leg-extension", name: "Extensión de cuádriceps", prescription: "2 × 12–15", rest: "60–75 s", cue: "Pausa arriba", guideReferences: [reference("thursday-leg-extension-guide", "Extensión de cuádriceps", "thursday-leg-extension")]),
                PrescribedExercise(id: "thursday-machine-hip-thrust", name: "Hip thrust en máquina", prescription: "3 × 8–12", rest: "90 s", cue: "No hiperextiendas la espalda", guideReferences: [reference("thursday-machine-hip-thrust-guide", "Hip thrust en máquina", "thursday-machine-hip-thrust")]),
                PrescribedExercise(id: "thursday-machine-calf-raise", name: "Gemelos en máquina", prescription: "4 × 10–15", rest: "60 s", cue: "Recorrido completo", guideReferences: [reference("thursday-machine-calf-raise-guide", "Gemelos en máquina", "thursday-machine-calf-raise")]),
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
                PrescribedExercise(id: "saturday-dumbbell-or-machine-incline-press", name: "Press inclinado con mancuernas o máquina", prescription: "3 × 8–12", rest: "90 s", cue: "Pecho superior", guideReferences: [reference("saturday-incline-press-dumbbell", "Press inclinado con mancuernas", "saturday-dumbbell-incline-press"), reference("saturday-incline-press-machine", "Press inclinado en máquina", "monday-machine-incline-press")]),
                PrescribedExercise(id: "saturday-neutral-grip-pulldown", name: "Jalón neutro", prescription: "3 × 8–12", rest: "90 s", cue: "Control total", guideReferences: [reference("saturday-neutral-grip-pulldown-guide", "Jalón neutro", "saturday-neutral-grip-pulldown")]),
                PrescribedExercise(id: "saturday-chest-supported-row", name: "Remo pecho apoyado", prescription: "3 × 10–12", rest: "90 s", cue: "Sin balanceo", guideReferences: [reference("saturday-chest-supported-row-guide", "Remo pecho apoyado", "saturday-chest-supported-row")]),
                PrescribedExercise(id: "saturday-lateral-raise", name: "Elevación lateral", prescription: "3 × 12–20", rest: "60 s", cue: "Sin encoger hombros", guideReferences: [reference("saturday-lateral-raise-guide", "Elevación lateral", "saturday-lateral-raise")]),
                PrescribedExercise(id: "saturday-cable-triceps", name: "Tríceps en polea", prescription: "2 × 10–15", rest: "60 s", cue: "RIR 1–2", guideReferences: [reference("saturday-cable-triceps-guide", "Tríceps en polea", "saturday-cable-triceps")]),
                PrescribedExercise(id: "saturday-cable-curl", name: "Curl en polea", prescription: "2 × 10–15", rest: "60 s", cue: "RIR 1–2", guideReferences: [reference("saturday-cable-curl-guide", "Curl en polea", "saturday-cable-curl")]),
            ],
            recoveryItems: []
        ),
        RoutineDay(
            id: "sunday", name: "Domingo", title: "Lower B + Core", subtitle: "Cadena posterior, abdomen y cardio", kind: .strength,
            note: "Cardio zona 2: 25–35 min. Debes poder hablar en frases cortas sin jadear.",
            exercises: [
                PrescribedExercise(id: "sunday-dumbbell-romanian-deadlift", name: "Peso muerto rumano con mancuernas", prescription: "3 × 8–12", rest: "120 s", cue: "Cadera hacia atrás", guideReferences: [reference("sunday-dumbbell-rdl-guide", "Peso muerto rumano con mancuernas", "sunday-dumbbell-rdl")]),
                PrescribedExercise(id: "sunday-leg-curl", name: "Curl femoral", prescription: "3 × 10–15", rest: "75–90 s", cue: "Controla el regreso", guideReferences: [reference("sunday-leg-curl-guide", "Curl femoral", "sunday-leg-curl")]),
                PrescribedExercise(id: "sunday-comfortable-stance-leg-press", name: "Prensa, postura cómoda", prescription: "3 × 10–15", rest: "90 s", cue: "No bloquees rodillas", guideReferences: [reference("sunday-comfortable-stance-leg-press-guide", "Prensa, postura cómoda", "sunday-leg-press")]),
                PrescribedExercise(id: "sunday-machine-abductors", name: "Abductores en máquina", prescription: "3 × 15–20", rest: "60 s", cue: "Pausa exterior", guideReferences: [reference("sunday-machine-abductors-guide", "Abductores en máquina", "sunday-abductors")]),
                PrescribedExercise(id: "sunday-machine-or-cable-crunch", name: "Crunch en máquina o polea", prescription: "3 × 10–15", rest: "60 s", cue: "Flexiona el tronco", guideReferences: [reference("sunday-crunch-machine", "Crunch en máquina", "sunday-machine-crunch"), reference("sunday-crunch-cable", "Crunch en polea", "sunday-cable-crunch")]),
                PrescribedExercise(id: "sunday-plank", name: "Plancha", prescription: "3 × 25–45 s", rest: "60 s", cue: "Respira y mantén postura", guideReferences: [reference("sunday-plank-guide", "Plancha", "sunday-plank")]),
            ],
            recoveryItems: []
        ),
    ]

    private static func reference(_ id: String, _ title: String, _ guideID: String) -> ExerciseGuideReference {
        ExerciseGuideReference(id: id, title: title, guideID: guideID)
    }
}
