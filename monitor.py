import pygame
import psutil
import socket
import time
import os
import datetime

# Initialisiere pygame und setze den Vollbildmodus
pygame.init()
screen = pygame.display.set_mode((480, 320), pygame.FULLSCREEN)
pygame.display.set_caption("System Monitor")

# Schriftart und Größe festlegen
font = pygame.font.SysFont(None, 28)
title_font = pygame.font.SysFont(None, 48)  # Erhöhte Schriftgröße für den Titel

# Farben definieren
background_color = (30, 30, 30)  # Dunkelgrau Hintergrund
bar_color = (50, 150, 200)       # Hellblau für Balken
text_color = (255, 255, 255)     # Weiß für Text
border_color = (100, 100, 100)   # Grau für Rahmen
button_color = (80, 80, 80)      # Dunkelgrau für Buttons
button_hover_color = (100, 100, 100)  # Helleres Grau für Hover-Effekte

# Button Dimensionen
button_width = 50
button_height = 50
button_radius = 10  # Radius für abgerundete Ecken

# Vorherige Netzwerknutzungsdaten initialisieren
previous_net_sent = 0
previous_net_recv = 0

# Funktion zur Formatierung der Netzwerknutzungsdaten
def format_network_usage(bytes):
    if bytes < 1024:
        return f"{bytes:.2f} B"
    elif bytes < 1024 * 1024:
        return f"{bytes / 1024:.2f} KB"
    elif bytes < 1024 * 1024 * 1024:
        return f"{bytes / (1024 * 1024):.2f} MB"
    else:
        return f"{bytes / (1024 * 1024 * 1024):.2f} GB"

# Funktion zur Bestimmung der aktuellen IP-Adresse und des Interfaces
def get_ip_and_interface():
    try:
        interfaces = psutil.net_if_addrs()
        ip_address = "N/A"
        interface_name = "N/A"

        for interface, addrs in interfaces.items():
            for addr in addrs:
                if addr.family == socket.AF_INET and not addr.address.startswith("127."):
                    ip_address = addr.address
                    interface_name = interface
                    break
            if ip_address != "N/A":
                break

        if ip_address == "N/A":
            ip_address = socket.gethostbyname(socket.gethostname())
        
        return ip_address, interface_name
    except Exception as e:
        print(f"Error getting IP and interface: {e}")
        return "N/A", "N/A"

# Funktion zum Zeichnen eines Balkendiagramms mit abgerundeten Ecken
def draw_rounded_bar(screen, x, y, width, height, percentage, color, radius):
    inner_width = int(width * percentage / 100)
    bar_rect = pygame.Rect(x, y, inner_width, height)
    bar_outline = pygame.Rect(x, y, width, height)
    
    pygame.draw.rect(screen, background_color, bar_outline)
    pygame.draw.rect(screen, color, bar_rect, border_radius=radius)
    pygame.draw.rect(screen, border_color, bar_outline, 2, border_radius=radius)

# Funktion zum Zeichnen eines Buttons
def draw_rounded_button(screen, x, y, text, color, hover_color, width, height, radius):
    mouse_pos = pygame.mouse.get_pos()
    mouse_click = pygame.mouse.get_pressed()
    
    button_rect = pygame.Rect(x, y, width, height)
    
    if button_rect.collidepoint(mouse_pos):
        pygame.draw.rect(screen, hover_color, button_rect, border_radius=radius)
        if mouse_click[0]:  # Wenn die linke Maustaste gedrückt wird
            return True
    else:
        pygame.draw.rect(screen, color, button_rect, border_radius=radius)
    
    text_surf = font.render(text, True, text_color)
    text_rect = text_surf.get_rect(center=button_rect.center)
    screen.blit(text_surf, text_rect)
    
    return False

def get_system_stats():
    global previous_net_sent, previous_net_recv
    
    try:
        cpu_usage = psutil.cpu_percent()
        ram_info = psutil.virtual_memory()
        disk_info = psutil.disk_usage('/')
        net_info = psutil.net_io_counters()

        net_sent = (net_info.bytes_sent - previous_net_sent)
        net_recv = (net_info.bytes_recv - previous_net_recv)

        previous_net_sent = net_info.bytes_sent
        previous_net_recv = net_info.bytes_recv

        temp = os.popen("vcgencmd measure_temp").readline()
        cpu_temp = temp.replace("temp=", "").replace("'C\n", "")

        uptime_seconds = time.time() - psutil.boot_time()
        uptime_str = str(datetime.timedelta(seconds=int(uptime_seconds)))

        ip_address, interface_name = get_ip_and_interface()

        return {
            "cpu_usage": cpu_usage,
            "ram_total": ram_info.total,
            "ram_available": ram_info.available,
            "ram_used": ram_info.used,
            "ram_usage": ram_info.percent,
            "disk_total": disk_info.total,
            "disk_used": disk_info.used,
            "disk_free": disk_info.free,
            "disk_usage": disk_info.percent,
            "net_sent": format_network_usage(net_sent),
            "net_recv": format_network_usage(net_recv),
            "cpu_temp": cpu_temp,
            "uptime": uptime_str,
            "ip_address": ip_address,
            "interface": interface_name
        }
    except Exception as e:
        print(f"Error getting system stats: {e}")
        return {
            "cpu_usage": 0,
            "ram_total": 0,
            "ram_available": 0,
            "ram_used": 0,
            "ram_usage": 0,
            "disk_total": 0,
            "disk_used": 0,
            "disk_free": 0,
            "disk_usage": 0,
            "net_sent": "N/A",
            "net_recv": "N/A",
            "cpu_temp": "N/A",
            "uptime": "N/A",
            "ip_address": "N/A",
            "interface": "N/A"
        }

def display_stats(screen, stats):
    screen.fill(background_color)

    title_text = title_font.render("System Monitor", True, text_color)
    screen.blit(title_text, (20, 10))

    cpu_text = font.render(f"CPU: {stats['cpu_usage']}%", True, text_color)
    ram_text = font.render(f"RAM: {format_network_usage(stats['ram_used'])} / {format_network_usage(stats['ram_available'])} ({stats['ram_usage']}%)", True, text_color)
    disk_text = font.render(f"Disk: {format_network_usage(stats['disk_used'])} / {format_network_usage(stats['disk_free'])} ({stats['disk_usage']}%)", True, text_color)
    net_text = font.render(f"Net Sent: {stats['net_sent']}, Recv: {stats['net_recv']}", True, text_color)
    temp_text = font.render(f"CPU Temp: {stats['cpu_temp']}°C", True, text_color)
    uptime_text = font.render(f"Uptime: {stats['uptime']}", True, text_color)
    ip_text = font.render(f"IP: {stats['ip_address']}", True, text_color)
    iface_text = font.render(f"Interface: {stats['interface']}", True, text_color)

    draw_rounded_bar(screen, 20, 60, 440, 30, stats['cpu_usage'], bar_color, 10)
    draw_rounded_bar(screen, 20, 100, 440, 30, stats['ram_usage'], bar_color, 10)
    draw_rounded_bar(screen, 20, 140, 440, 30, stats['disk_usage'], bar_color, 10)

    cpu_text_rect = cpu_text.get_rect(topleft=(20 + 5, 60 + 5))
    ram_text_rect = ram_text.get_rect(topleft=(20 + 5, 100 + 5))
    disk_text_rect = disk_text.get_rect(topleft=(20 + 5, 140 + 5))
    screen.blit(cpu_text, cpu_text_rect)
    screen.blit(ram_text, ram_text_rect)
    screen.blit(disk_text, disk_text_rect)

    # Angepasster Abstand zwischen Disk- und Netzanzeige
    net_text_y_position = 200  # Mittelwert des Abstands
    screen.blit(net_text, (20, net_text_y_position))
    screen.blit(temp_text, (20, net_text_y_position + 40))  # Verschiebt die Temperaturanzeige weiter nach unten
    screen.blit(uptime_text, (20, net_text_y_position + 80))  # Verschiebt die Uptime-Anzeige weiter nach unten
    screen.blit(ip_text, (230, net_text_y_position + 40))  # Verschiebt die IP-Adresse weiter nach unten
    screen.blit(iface_text, (230, net_text_y_position + 80))  # Verschiebt das Interface weiter nach unten

    # Buttons zeichnen (Positioniert unten rechts)
    button_margin = 20
    # Verschiebt den Restart-Button um 15 Pixel tiefer
    restart_button_y = 320 - button_height - button_margin * 2 - button_height + 15
    restart_button_clicked = draw_rounded_button(screen, 480 - button_width - button_margin, restart_button_y, "R", button_color, button_hover_color, button_width, button_height, button_radius)
    shutdown_button_clicked = draw_rounded_button(screen, 480 - button_width - button_margin, 320 - button_height - button_margin, "S", button_color, button_hover_color, button_width, button_height, button_radius)

    if restart_button_clicked:
        os.system("sudo reboot")
    if shutdown_button_clicked:
        os.system("sudo shutdown now")

    pygame.display.update()

def main():
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        stats = get_system_stats()
        display_stats(screen, stats)

        # Optimiertes Sleep-Intervall
        time.sleep(1)

    pygame.quit()

if __name__ == "__main__":
    main()
