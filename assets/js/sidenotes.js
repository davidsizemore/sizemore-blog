document.addEventListener('DOMContentLoaded', function() {
    // Create popup container if it doesn't exist
    let popupContainer = document.getElementById('sidenote-popup-container');
    if (!popupContainer) {
        popupContainer = document.createElement('div');
        popupContainer.id = 'sidenote-popup-container';
        document.body.appendChild(popupContainer);
    }

    // Find all sidenote text elements
    const sidenoteTexts = document.querySelectorAll('.sidenote-text');
    
    sidenoteTexts.forEach(function(sidenoteText) {
        // Get the sidenote content
        const sidenoteId = sidenoteText.getAttribute('data-sidenote-id');
        const sidenote = document.querySelector(`.sidenote[data-sidenote-id="${sidenoteId}"]`);
        
        if (sidenote) {
            // Create popup for this sidenote
            const popup = document.createElement('div');
            popup.className = 'sidenote-popup';
            popup.setAttribute('data-sidenote-id', sidenoteId);
            
            // Add close button
            const closeButton = document.createElement('span');
            closeButton.className = 'sidenote-popup-close';
            closeButton.innerHTML = '&times;';
            closeButton.addEventListener('click', function(e) {
                e.stopPropagation();
                popup.style.display = 'none';
                sidenoteText.classList.remove('active');
            });
            
            // Clone sidenote content
            const content = sidenote.cloneNode(true);
            content.classList.remove('sidenote');
            content.style.display = 'block'; // Ensure content is visible in popup
            
            // Add content to popup
            popup.appendChild(closeButton);
            popup.appendChild(content);
            
            // Add popup to container
            popupContainer.appendChild(popup);
            
            // Add click event to sidenote text
            sidenoteText.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                // Hide all other popups
                document.querySelectorAll('.sidenote-popup').forEach(function(p) {
                    p.style.display = 'none';
                });
                
                // Remove active class from all sidenote texts
                document.querySelectorAll('.sidenote-text').forEach(function(st) {
                    st.classList.remove('active');
                });
                
                // Ensure popup is visible in viewport
                popup.style.display = 'block';
                popup.style.opacity = '1';
                sidenoteText.classList.add('active');
            });
        }
    });
    
    // Close popups when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.sidenote-text') && !e.target.closest('.sidenote-popup')) {
            document.querySelectorAll('.sidenote-popup').forEach(function(popup) {
                popup.style.display = 'none';
            });
            document.querySelectorAll('.sidenote-text').forEach(function(st) {
                st.classList.remove('active');
            });
        }
    });
}); 