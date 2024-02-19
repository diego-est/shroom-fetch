use fmt;
use strings;
use shlex;
use os;
use io;

fn fgblack(text: str) str = strings::concat("\x1B[30m", text, "\x1B[0m");
fn fgred(text: str) str = strings::concat("\x1B[31m", text, "\x1B[0m");
fn fggreen(text: str) str = strings::concat("\x1B[32m", text, "\x1B[0m");
fn fgyellow(text: str) str = strings::concat("\x1B[33m", text, "\x1B[0m");
fn fgblue(text: str) str = strings::concat("\x1B[34m", text, "\x1B[0m");
fn fgmagenta(text: str) str = strings::concat("\x1B[34m", text, "\x1B[0m");
fn fgcyan(text: str) str = strings::concat("\x1B[35m", text, "\x1B[0m");
fn fgwhite(text: str) str = strings::concat("\x1B[36m", text, "\x1B[0m");

export fn main() void = {
	const WM = fgmagenta("WM");
	defer free(WM);

	const DISTRO = fggreen("Distro");
	defer free(DISTRO);

	const SHELL = fgblue("Shell");
	defer free(SHELL);

	const TERM = fgcyan("Term");
	defer free(TERM);

	let user = match (os::getenv("USER")) {
	case let u: str => yield u;
	case void => yield "NONE";
	};
	const USER = fgyellow(user);
	defer free(USER);

	let hostname = os::hostname();
	const MACHINE = strings::rpad(fgyellow(hostname), ' ', 39 - len(user) - len(hostname));
	defer free(MACHINE);

	let os_release_path = os::open("/etc/os-release")!;
	let os_name: [16]u8 = [0...];
	io::read(os_release_path, os_name)!;
	let os_name = strings::fromutf8(os_name)!;
	let os_name = strings::trimprefix(os_name, "NAME=\"");
	const DISTRO_NAME = strings::rpad(fggreen(os_name), ' ', 21);
	defer free(DISTRO_NAME);

	let shell = match (os::getenv("SHELL")) {
	case let s: str => yield s;
	case void => yield "NONE";
	};
	const SHELL_NAME = strings::rpad(fgblue(shell), ' ', 19);
	defer free(SHELL_NAME);

	let term = match (os::getenv("TERM")) {
	case let t: str => yield t;
	case void => yield "NONE";
	};
	const TERM_NAME = strings::rpad(fgcyan(term), ' ', 21);
	defer free(TERM_NAME);

	let wm = match (os::getenv("XDG_DESKTOP_SESSION")) {
	case let wm: str => yield wm;
	case void => yield match (os::getenv("DESKTOP_SESSION")) {
		case let wm: str => yield wm;
		case void => yield match (os::getenv("WM")) {
			case let wm: str => yield  wm;
			case void => yield "NONE";
			};
		};
	};
	const WM_NAME = strings::rpad(fgmagenta(wm), ' ', 20);
	defer free(WM_NAME);

	const ART = strings::concat("                           .-'~~~-.           
  {}@{}.'o  ", fgred("oOOOo"), "`.         
                        :~~~-.", fgred("oOo"), "   o`.       
     {}  : {}`. \\ ~-.  ", fgred("oOOo"), ".      
     {} : {}`.", fgyellow(";"), " / ~.  ", fgred("OO"), ":      
     {}   : {}", fgyellow(".'  ;"), "-- `.o.'      
     {}     : {}", fgyellow(",'  ;"), " ~~--'~        
                          ", fgyellow(";  ;"), "                
___________\\|/__________\\\\", fgyellow(";"), "_\\\\//___\\|/________");
	defer free(ART);
	fmt::printf(ART, USER, MACHINE, SHELL, SHELL_NAME, DISTRO, DISTRO_NAME, TERM, TERM_NAME, WM, WM_NAME)!;
};
