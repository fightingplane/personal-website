// Add global avatar to top-left corner
document.addEventListener('DOMContentLoaded', function() {
    // Create avatar container
    const avatarContainer = document.createElement('div');
    avatarContainer.style.position = 'fixed';
    avatarContainer.style.top = '20px';
    avatarContainer.style.left = '20px';
    avatarContainer.style.zIndex = '1000';
    avatarContainer.style.width = '60px';
    avatarContainer.style.height = '60px';
    avatarContainer.style.borderRadius = '50%';
    avatarContainer.style.overflow = 'hidden';
    avatarContainer.style.boxShadow = '0 2px 10px rgba(0,0,0,0.3)';
    
    // Create avatar image
    const avatarImg = document.createElement('img');
    avatarImg.src = '/images/avatar.jpg';
    avatarImg.alt = 'Profile Avatar';
    avatarImg.style.width = '100%';
    avatarImg.style.height = '100%';
    avatarImg.style.objectFit = 'cover';
    
    // Add hover effect
    avatarContainer.addEventListener('mouseenter', function() {
        avatarContainer.style.transform = 'scale(1.1)';
        avatarContainer.style.transition = 'transform 0.2s ease';
    });
    
    avatarContainer.addEventListener('mouseleave', function() {
        avatarContainer.style.transform = 'scale(1)';
        avatarContainer.style.transition = 'transform 0.2s ease';
    });
    
    // Append to body
    avatarContainer.appendChild(avatarImg);
    document.body.appendChild(avatarContainer);
});