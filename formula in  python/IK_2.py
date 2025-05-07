import matplotlib.pyplot as plt
import math

# Panjang tulang
L1 = 3
L2 = 2

# Titik awal (shoulder)
x0, y0 = 0, 0

# Titik target awal
tx, ty = 4, 2

flip = False


# Fungsi untuk menghitung dan menggambar IK dua tulang
def update_ik(tx, ty):
    # Jarak ke target
    dist = math.sqrt((tx - x0)**2 + (ty - y0)**2)
    dist = min(dist, L1 + L2)  # Pastikan target dalam jangkauan

    # Sudut siku (theta2)
    cos_theta2 = (dist**2 - L1**2 - L2**2) / (2 * L1 * L2)
    cos_theta2 = max(min(cos_theta2, 1), -1)  # Clamp untuk keamanan
    theta2 = math.acos(cos_theta2)

    # Sudut shoulder (theta1)
    angle_to_target = math.atan2(ty - y0, tx - x0)
    cos_alpha = (dist**2 + L1**2 - L2**2) / (2 * dist * L1)
    cos_alpha = max(min(cos_alpha, 1), -1)  # Clamp
    alpha = math.acos(cos_alpha)
    theta1 = angle_to_target - alpha

    neg = 1
    if flip:
        neg = -1
        theta2 = -theta2
        
    theta1 = angle_to_target - (alpha*neg)

    # Posisi siku (elbow)
    x1 = x0 + L1 * math.cos(theta1)
    y1 = y0 + L1 * math.sin(theta1)

    # Posisi end-effector
    x2 = x1 + L2 * math.cos(theta1 + theta2)
    y2 = y1 + L2 * math.sin(theta1 + theta2)

    # Gambar ulang
    plt.cla()
    plt.plot([x0, x1], [y0, y1], marker='o', label='Bone 1')
    plt.plot([x1, x2], [y1, y2], marker='o', label='Bone 2')
    plt.scatter([tx], [ty], color='red', label='Target')
    plt.axhline(0, color='grey', linestyle='--')
    plt.axvline(0, color='grey', linestyle='--')
    plt.xlim(-5, 5)
    plt.ylim(-5, 5)
    plt.legend()
    plt.gca().set_aspect('equal', adjustable='box')
    plt.title('Real-time IK Dua Tulang')
    plt.draw()

# Fungsi saat mouse diklik
def on_click(event):
    global tx, ty
    if event.xdata is not None and event.ydata is not None:
        tx, ty = event.xdata, event.ydata
        update_ik(tx, ty)

# Inisialisasi plot
plt.figure(figsize=(6, 6))
plt.connect('button_press_event', on_click)
update_ik(tx, ty)
plt.show()
