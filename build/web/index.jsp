<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    if (username != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu Billing System</title>
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #000000 0%, #2c2c2c 50%, #B0B0B0 100%);
            min-height: 200vh; /* Extra height to enable scrolling */
            overflow-x: hidden;
            color: #ffffff;
        }

        /* Canvas for particle animation */
        #particleCanvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            pointer-events: none;
        }

        /* Main Container */
        .container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 2rem;
            position: relative;
            z-index: 1;
        }

        /* Header Styles */
        .main-header {
            text-align: center;
            margin-bottom: 2rem;
            opacity: 0;
            transform: translateX(-100px);
            transition: all 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        .main-header.animate {
            opacity: 1;
            transform: translateX(0);
        }

        .main-header h1 {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 700;
            color: #1976D2;
            text-shadow: 0 0 20px rgba(25, 118, 210, 0.3);
            margin-bottom: 1rem;
            letter-spacing: -1px;
        }

        .main-header .subtitle {
            font-size: clamp(1.1rem, 2.5vw, 1.3rem);
            color: #B0B0B0;
            font-weight: 300;
            letter-spacing: 0.5px;
        }

        /* Description Paragraph */
        .description {
            max-width: 600px;
            text-align: center;
            font-size: clamp(1rem, 2vw, 1.2rem);
            line-height: 1.8;
            color: #B0B0B0;
            margin-bottom: 3rem;
            opacity: 0;
            transform: translateX(-100px);
            transition: all 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            transition-delay: 0.2s;
            background: rgba(255, 255, 255, 0.05);
            padding: 2rem;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(25, 118, 210, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .description.animate {
            opacity: 1;
            transform: translateX(0);
        }

        /* Login Button */
        .login-button {
            opacity: 0;
            transform: translateX(100px);
            transition: all 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            transition-delay: 0.4s;
        }

        .login-button.animate {
            opacity: 1;
            transform: translateX(0);
        }

        .login-btn {
            display: inline-block;
            padding: 1.2rem 3rem;
            background: linear-gradient(135deg, #1976D2 0%, #1565C0 100%);
            color: white;
            text-decoration: none;
            font-size: 1.2rem;
            font-weight: 600;
            border-radius: 50px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(25, 118, 210, 0.3);
            border: 2px solid transparent;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            overflow: hidden;
        }

        .login-btn:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .login-btn:hover:before {
            left: 100%;
        }

        .login-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(25, 118, 210, 0.4);
            border-color: rgba(176, 176, 176, 0.3);
        }

        .login-btn:active {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(25, 118, 210, 0.3);
        }

        /* Feature Cards Section */
        .features-section {
            margin-top: 5rem;
            width: 100%;
            /* max-width: 1200px; */
        }

        .features-grid {
            display: flex;
            justify-content: space-evenly;
            align-items: stretch;
            gap: 2rem;
            padding: 2rem 0;
            flex-wrap: wrap;
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 2rem;
            border: 1px solid rgba(25, 118, 210, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            transition: all 0.3s ease;
            opacity: 0;
            transform: translateY(50px);
            flex: 1;
            min-width: 280px;
            max-width: 350px;
        }

        .feature-card.animate {
            opacity: 1;
            transform: translateY(0);
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(25, 118, 210, 0.2);
            border-color: rgba(25, 118, 210, 0.4);
        }

        .feature-card h3 {
            color: #1976D2;
            font-size: 1.5rem;
            margin-bottom: 1rem;
            text-align: center;
        }

        .feature-card p {
            color: #B0B0B0;
            text-align: center;
            line-height: 1.6;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .description {
                padding: 1.5rem;
                margin-bottom: 2rem;
            }

            .login-btn {
                padding: 1rem 2rem;
                font-size: 1.1rem;
            }

            .features-grid {
                flex-direction: column;
                align-items: center;
                gap: 1.5rem;
            }

            .feature-card {
                max-width: 100%;
                min-width: auto;
            }
        }

        @media (max-width: 480px) {
            .main-header h1 {
                font-size: 2rem;
            }

            .main-header .subtitle {
                font-size: 1rem;
            }

            .description {
                font-size: 0.95rem;
                padding: 1rem;
            }

            .login-btn {
                padding: 0.8rem 1.5rem;
                font-size: 1rem;
            }
        }

        /* Floating Book Animation */
        .floating-book {
            position: fixed;
            width: 60px;
            height: 45px;
            background: linear-gradient(135deg, #1976D2 0%, #1565C0 100%);
            border-radius: 8px;
            box-shadow: 0 8px 25px rgba(25, 118, 210, 0.3);
            z-index: 10;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            animation: floatSlow 8s ease-in-out infinite;
        }

        .floating-book::before {
            content: '';
            position: absolute;
            top: 5px;
            left: 5px;
            right: 5px;
            bottom: 15px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
        }

        .floating-book::after {
            content: '';
            position: absolute;
            bottom: 8px;
            left: 8px;
            right: 8px;
            height: 2px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 1px;
            box-shadow: 
                0 -4px 0 rgba(255, 255, 255, 0.15),
                0 -8px 0 rgba(255, 255, 255, 0.1);
        }

        .floating-book.avoiding {
            transform: scale(1.1);
            box-shadow: 0 12px 35px rgba(25, 118, 210, 0.5);
        }

        @keyframes floatSlow {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            25% {
                transform: translateY(-15px) rotate(2deg);
            }
            50% {
                transform: translateY(-5px) rotate(0deg);
            }
            75% {
                transform: translateY(-20px) rotate(-2deg);
            }
        }

        /* Scroll indicator */
        .scroll-indicator {
            position: absolute;
            bottom: 2rem;
            left: 50%;
            transform: translateX(-50%);
            color: #B0B0B0;
            font-size: 0.9rem;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateX(-50%) translateY(0);
            }
            40% {
                transform: translateX(-50%) translateY(-10px);
            }
            60% {
                transform: translateX(-50%) translateY(-5px);
            }
        }
    </style>
</head>
<body>
    <!-- Particle Animation Canvas -->
    <canvas id="particleCanvas"></canvas>

    <!-- Floating Book -->
    <div class="floating-book" id="floatingBook"></div>

    <!-- Main Content Container -->
    <div class="container">
        <!-- Main Header -->
        <header class="main-header" id="mainHeader">
            <h1>Welcome to Pahana Edu Billing System</h1>
            <p class="subtitle">Smart • Efficient • Reliable</p>
        </header>

        <!-- Description -->
        <div class="description" id="description">
            <p>Experience the next generation of educational billing management. Our comprehensive system streamlines fee collection, generates detailed reports, and provides real-time analytics to help educational institutions manage their finances with unprecedented ease and accuracy.</p>
        </div>

        <!-- Login Button -->
        <div class="login-button" id="loginButton">
            <a href="login.jsp"  target="_blank" class="login-btn">
                Login to Continue
            </a>
        </div>

        <!-- Scroll Indicator -->
        <div class="scroll-indicator">
            ↓ Scroll to explore features ↓
        </div>
    </div>

    <!-- Features Section -->
    <div class="features-section">
        <div class="features-grid">
            <div class="feature-card" data-delay="0">
                <h3>Smart Analytics</h3>
                <p>Advanced reporting and analytics to track payments, outstanding fees, and financial trends in real-time.</p>
            </div>
            <div class="feature-card" data-delay="0.2">
                <h3>Automated Billing</h3>
                <p>Streamline your billing process with automated fee generation, reminders, and payment tracking.</p>
            </div>
            <div class="feature-card" data-delay="0.4">
                <h3>Secure & Reliable</h3>
                <p>Bank-level security with encrypted data storage and reliable backup systems for peace of mind.</p>
            </div>
        </div>
    </div>

    <div class="footer" style="position:fixed;left:0;bottom:0;width:100%;background:rgba(25,118,210,0.9);color:#fff;text-align:center;padding:1rem 0;font-size:1rem;z-index:100;">
        <p style="margin:0;">&copy; 2025 Pahana Edu Billing System. All rights reserved.</p>
        <p style="margin:0;">Developed by Pahana Edu</p>
    </div>

    <script>
        // Particle Animation System
        class ParticleSystem {
            constructor() {
                this.canvas = document.getElementById('particleCanvas');
                this.ctx = this.canvas.getContext('2d');
                this.particles = [];
                this.mouse = { x: 0, y: 0 };
                this.maxParticles = 100;
                
                this.initCanvas();
                this.createParticles();
                this.bindEvents();
                this.animate();
            }

            initCanvas() {
                this.canvas.width = window.innerWidth;
                this.canvas.height = window.innerHeight;
            }

            createParticles() {
                for (let i = 0; i < this.maxParticles; i++) {
                    this.particles.push({
                        x: Math.random() * this.canvas.width,
                        y: Math.random() * this.canvas.height,
                        vx: (Math.random() - 0.5) * 0.5,
                        vy: (Math.random() - 0.5) * 0.5,
                        radius: Math.random() * 2 + 1,
                        opacity: Math.random() * 0.5 + 0.2,
                        color: Math.random() > 0.5 ? '#1976D2' : '#B0B0B0'
                    });
                }
            }

            bindEvents() {
                window.addEventListener('resize', () => this.initCanvas());
                
                document.addEventListener('mousemove', (e) => {
                    this.mouse.x = e.clientX;
                    this.mouse.y = e.clientY;
                });
            }

            updateParticles() {
                this.particles.forEach(particle => {
                    // Mouse interaction
                    const dx = this.mouse.x - particle.x;
                    const dy = this.mouse.y - particle.y;
                    const distance = Math.sqrt(dx * dx + dy * dy);
                    
                    if (distance < 100) {
                        const force = (100 - distance) / 100;
                        particle.vx += (dx / distance) * force * 0.01;
                        particle.vy += (dy / distance) * force * 0.01;
                        particle.opacity = Math.min(1, particle.opacity + force * 0.02);
                    } else {
                        particle.opacity = Math.max(0.2, particle.opacity - 0.01);
                    }

                    // Update position
                    particle.x += particle.vx;
                    particle.y += particle.vy;

                    // Apply friction
                    particle.vx *= 0.98;
                    particle.vy *= 0.98;

                    // Boundary check
                    if (particle.x < 0 || particle.x > this.canvas.width) {
                        particle.vx *= -1;
                        particle.x = Math.max(0, Math.min(this.canvas.width, particle.x));
                    }
                    if (particle.y < 0 || particle.y > this.canvas.height) {
                        particle.vy *= -1;
                        particle.y = Math.max(0, Math.min(this.canvas.height, particle.y));
                    }
                });
            }

            drawParticles() {
                this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
                
                this.particles.forEach(particle => {
                    this.ctx.beginPath();
                    this.ctx.arc(particle.x, particle.y, particle.radius, 0, Math.PI * 2);
                    this.ctx.fillStyle = particle.color;
                    this.ctx.globalAlpha = particle.opacity;
                    this.ctx.fill();
                });

                // Draw connections
                this.particles.forEach((particle, i) => {
                    this.particles.slice(i + 1).forEach(otherParticle => {
                        const dx = particle.x - otherParticle.x;
                        const dy = particle.y - otherParticle.y;
                        const distance = Math.sqrt(dx * dx + dy * dy);
                        
                        if (distance < 80) {
                            this.ctx.beginPath();
                            this.ctx.moveTo(particle.x, particle.y);
                            this.ctx.lineTo(otherParticle.x, otherParticle.y);
                            this.ctx.strokeStyle = '#1976D2';
                            this.ctx.globalAlpha = (80 - distance) / 80 * 0.2;
                            this.ctx.lineWidth = 1;
                            this.ctx.stroke();
                        }
                    });
                });
            }

            animate() {
                this.updateParticles();
                this.drawParticles();
                requestAnimationFrame(() => this.animate());
            }
        }

        // Scroll Animation System
        class ScrollAnimations {
            constructor() {
                this.elements = [
                    { el: document.getElementById('mainHeader'), threshold: 0.1 },
                    { el: document.getElementById('description'), threshold: 0.1 },
                    { el: document.getElementById('loginButton'), threshold: 0.1 }
                ];
                
                this.featureCards = document.querySelectorAll('.feature-card');
                this.init();
            }

            init() {
                // Create intersection observer for main elements
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('animate');
                        }
                    });
                }, { threshold: 0.1 });

                // Observe main elements
                this.elements.forEach(item => {
                    if (item.el) {
                        observer.observe(item.el);
                    }
                });

                // Create observer for feature cards with staggered animation
                const cardObserver = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            const delay = entry.target.dataset.delay || 0;
                            setTimeout(() => {
                                entry.target.classList.add('animate');
                            }, delay * 1000);
                        }
                    });
                }, { threshold: 0.1 });

                // Observe feature cards
                this.featureCards.forEach(card => {
                    cardObserver.observe(card);
                });

                // Trigger initial animation if elements are already in view
                setTimeout(() => {
                    this.checkInitialVisibility();
                }, 100);
            }

            checkInitialVisibility() {
                this.elements.forEach(item => {
                    if (item.el && this.isElementInViewport(item.el)) {
                        item.el.classList.add('animate');
                    }
                });
            }

            isElementInViewport(el) {
                const rect = el.getBoundingClientRect();
                return (
                    rect.top >= 0 &&
                    rect.left >= 0 &&
                    rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
                    rect.right <= (window.innerWidth || document.documentElement.clientWidth)
                );
            }
        }

        // Floating Book Animation System
        class FloatingBook {
            constructor() {
                this.book = document.getElementById('floatingBook');
                this.mouse = { x: 0, y: 0 };
                this.position = { 
                    x: Math.random() * (window.innerWidth - 100) + 50, 
                    y: Math.random() * (window.innerHeight - 100) + 50 
                };
                this.velocity = { x: 0, y: 0 };
                this.avoidanceRadius = 120;
                this.maxSpeed = 3;
                this.friction = 0.95;
                
                this.init();
                this.animate();
            }

            init() {
                this.updateBookPosition();
                
                // Track mouse movement
                document.addEventListener('mousemove', (e) => {
                    this.mouse.x = e.clientX;
                    this.mouse.y = e.clientY;
                });

                // Handle window resize
                window.addEventListener('resize', () => {
                    this.position.x = Math.min(this.position.x, window.innerWidth - 100);
                    this.position.y = Math.min(this.position.y, window.innerHeight - 100);
                });
            }

            updateBookPosition() {
                this.book.style.left = this.position.x + 'px';
                this.book.style.top = this.position.y + 'px';
            }

            avoidMouse() {
                const dx = this.mouse.x - (this.position.x + 30); // 30 is half book width
                const dy = this.mouse.y - (this.position.y + 22.5); // 22.5 is half book height
                const distance = Math.sqrt(dx * dx + dy * dy);

                if (distance < this.avoidanceRadius && distance > 0) {
                    // Calculate avoidance force
                    const force = (this.avoidanceRadius - distance) / this.avoidanceRadius;
                    const avoidanceForceX = -(dx / distance) * force * 0.8;
                    const avoidanceForceY = -(dy / distance) * force * 0.8;

                    // Apply force
                    this.velocity.x += avoidanceForceX;
                    this.velocity.y += avoidanceForceY;

                    // Add avoiding class for visual feedback
                    this.book.classList.add('avoiding');
                } else {
                    this.book.classList.remove('avoiding');
                }
            }

            constrainToScreen() {
                const margin = 20;
                
                if (this.position.x < margin) {
                    this.position.x = margin;
                    this.velocity.x = Math.abs(this.velocity.x);
                }
                if (this.position.x > window.innerWidth - 60 - margin) {
                    this.position.x = window.innerWidth - 60 - margin;
                    this.velocity.x = -Math.abs(this.velocity.x);
                }
                if (this.position.y < margin) {
                    this.position.y = margin;
                    this.velocity.y = Math.abs(this.velocity.y);
                }
                if (this.position.y > window.innerHeight - 45 - margin) {
                    this.position.y = window.innerHeight - 45 - margin;
                    this.velocity.y = -Math.abs(this.velocity.y);
                }
            }

            animate() {
                // Avoid mouse
                this.avoidMouse();

                // Limit velocity
                const speed = Math.sqrt(this.velocity.x * this.velocity.x + this.velocity.y * this.velocity.y);
                if (speed > this.maxSpeed) {
                    this.velocity.x = (this.velocity.x / speed) * this.maxSpeed;
                    this.velocity.y = (this.velocity.y / speed) * this.maxSpeed;
                }

                // Update position
                this.position.x += this.velocity.x;
                this.position.y += this.velocity.y;

                // Apply friction
                this.velocity.x *= this.friction;
                this.velocity.y *= this.friction;

                // Keep book on screen
                this.constrainToScreen();

                // Update DOM
                this.updateBookPosition();

                // Continue animation
                requestAnimationFrame(() => this.animate());
            }
        }

        // Smooth scrolling for better user experience
        function addSmoothScrolling() {
            document.documentElement.style.scrollBehavior = 'smooth';
        }

        // Initialize everything when DOM is loaded
        document.addEventListener('DOMContentLoaded', () => {
            // Initialize particle system
            new ParticleSystem();
            
            // Initialize floating book
            new FloatingBook();
            
            // Initialize scroll animations
            new ScrollAnimations();
            
            // Add smooth scrolling
            addSmoothScrolling();
            
            // Add loading animation
            document.body.style.opacity = '0';
            setTimeout(() => {
                document.body.style.transition = 'opacity 1s ease';
                document.body.style.opacity = '1';
            }, 100);
        });

        // Handle window resize for responsive canvas
        window.addEventListener('resize', () => {
            const canvas = document.getElementById('particleCanvas');
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        });
    </script>
</body>
</html>