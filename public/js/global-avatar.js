(function() {
    // Create avatar container
    var avatarContainer = document.createElement('div');
    avatarContainer.id = 'global-avatar-container';
    
    // Create avatar image
    var avatarImg = document.createElement('img');
    avatarImg.src = '/images/avatar.jpg';
    avatarImg.alt = 'Profile Picture';
    avatarImg.id = 'global-avatar';
    
    // Append image to container
    avatarContainer.appendChild(avatarImg);
    
    // Add to body
    document.body.appendChild(avatarContainer);
    
    // Add CSS styles
    var style = document.createElement('style');
    style.textContent = `
        #global-avatar-container {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1000;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
            transition: transform 0.2s ease;
        }
        
        #global-avatar-container:hover {
            transform: scale(1.1);
        }
        
        #global-avatar {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        
        @media (max-width: 768px) {
            #global-avatar-container {
                width: 45px;
                height: 45px;
                top: 15px;
                left: 15px;
            }
        }
    `;
    document.head.appendChild(style);
})();