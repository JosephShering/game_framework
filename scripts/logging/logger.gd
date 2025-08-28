## A utility class for wrapping logging/debugging functionality.
class_name Logger extends RefCounted

enum Severity {INFO, WARNING, ERROR, IMPORTANT}

static var multiplayer_id: String = "Unassigned"
static var multiplayer_username: String = "Unassigned"


## Sets the multiplayer id that is used in the final formatted message when logging.
static func set_multiplayer_id(new_id: int) -> void:
    multiplayer_id = str(new_id)


## Sets the multiplayer username that is used in the final formatted message when logging.
static func set_multiplayer_username(new_username: String) -> void:
    multiplayer_username = new_username


static func print_info(message: String) -> void:
    log_message(message, Severity.INFO)


static func print_important(message: String) -> void:
    log_message(message, Severity.IMPORTANT)


static func print_error(message: String) -> void:
    log_message(message, Severity.ERROR)


static func log_message(message : String, severity : Severity) -> void:
    #var datetime_string = Time.get_time_string_from_system()
    #var formatted_message: String = datetime_string + " PEER-ID: " + multiplayer_id + " -> " + message
    var formatted_message: String = "[color=Cyan]" + multiplayer_username + " " + multiplayer_id + " -> [/color]" + message

    match severity:
        Severity.INFO:
            print_rich("[color=white]" + formatted_message + "[/color]")
        Severity.IMPORTANT:
            print_rich("[color=gold]" + formatted_message + "[/color]")
        Severity.ERROR:
            print_rich("[color=red]" + formatted_message + "[/color]")
