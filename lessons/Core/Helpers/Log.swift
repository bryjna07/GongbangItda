import OSLog

enum Log {

    // MARK: - Loggers (카테고리별)
    private static let network = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.watson.lessons",
        category: "Network"
    )
    private static let ui = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.watson.lessons",
        category: "UI"
    )
    private static let data = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.watson.lessons",
        category: "Data"
    )
    private static let socket = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.watson.lessons",
        category: "Socket"
    )
    private static let general = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.watson.lessons",
        category: "General"
    )

    // MARK: - Network
    enum Network {
        static func request(_ message: String) {
            #if DEBUG
            network.info("📤 \(message, privacy: .public)")
            #endif
        }

        static func response(_ message: String) {
            #if DEBUG
            network.info("📥 \(message, privacy: .public)")
            #endif
        }

        static func error(_ message: String) {
            network.error("❌ \(message, privacy: .public)")
        }
    }

    // MARK: - UI
    enum UI {
        static func lifecycle(_ message: String) {
            #if DEBUG
            ui.debug("🔄 \(message, privacy: .public)")
            #endif
        }

        static func action(_ message: String) {
            #if DEBUG
            ui.info("👆 \(message, privacy: .public)")
            #endif
        }
    }

    // MARK: - Data
    enum Data {
        static func save(_ message: String) {
            #if DEBUG
            data.info("💾 \(message, privacy: .public)")
            #endif
        }

        static func fetch(_ message: String) {
            #if DEBUG
            data.info("📂 \(message, privacy: .public)")
            #endif
        }

        static func error(_ message: String) {
            data.error("❌ \(message, privacy: .public)")
        }
    }

    // MARK: - Socket
    enum Socket {
        static func connect(_ message: String) {
            #if DEBUG
            socket.info("🔌 \(message, privacy: .public)")
            #endif
        }

        static func disconnect(_ message: String) {
            socket.warning("🔌 \(message, privacy: .public)")
        }

        static func send(_ message: String) {
            #if DEBUG
            socket.debug("📤 \(message, privacy: .public)")
            #endif
        }

        static func receive(_ message: String) {
            #if DEBUG
            socket.debug("📥 \(message, privacy: .public)")
            #endif
        }

        static func error(_ message: String) {
            socket.error("❌ \(message, privacy: .public)")
        }
    }

    // MARK: - General
    static func debug(_ message: String) {
        #if DEBUG
        general.debug("🔍 \(message, privacy: .public)")
        #endif
    }

    static func info(_ message: String) {
        #if DEBUG
        general.info("ℹ️ \(message, privacy: .public)")
        #endif
    }

    static func warning(_ message: String) {
        general.warning("⚠️ \(message, privacy: .public)")
    }

    static func error(_ message: String) {
        general.error("❌ \(message, privacy: .public)")
    }
}
