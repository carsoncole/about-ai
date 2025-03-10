// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


// app/javascript/application.js
document.addEventListener('DOMContentLoaded', () => {
  const chatContainer = document.getElementById('chat-container');
  const minimizeChat = document.getElementById('minimize-chat');
  const chatHeader = document.getElementById('chat-header');
  const chatBody = document.getElementById('chat-body');
  const chatForm = document.getElementById('chat-form');
  const chatInput = document.getElementById('chat-input');
  const chatMessages = document.getElementById('chat-messages');

  let isMinimized = false;

  // Toggle minimize/maximize
  const toggleMinimize = () => {
    isMinimized = !isMinimized;

    if (isMinimized) {
      chatBody.classList.add('hidden');
      chatContainer.classList.remove('max-h-[80vh]');
      chatContainer.classList.add('w-64');
      minimizeChat.innerHTML = `
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15h14M5 9h14" />
        </svg>
      `;
    } else {
      chatBody.classList.remove('hidden');
      chatContainer.classList.add('max-h-[80vh]');
      chatContainer.classList.remove('w-64');
      minimizeChat.innerHTML = `
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 12H6" />
        </svg>
      `;
    }
  };

  // Add event listener to header
  chatHeader.addEventListener('click', (e) => {
    // Only toggle if the click is directly on the header, not its children (like the button)
    if (e.target === chatHeader) {
      toggleMinimize();
    }
  });

  // Add event listener to minimize button and stop propagation
  minimizeChat.addEventListener('click', (e) => {
    e.stopPropagation(); // Prevent the event from bubbling up to the header
    toggleMinimize();
  });

  // Handle form submission
  chatForm.addEventListener('submit', async (e) => {
    e.preventDefault();

    const message = chatInput.value.trim();
    if (!message) return;

    // If minimized, maximize before adding message
    if (isMinimized) toggleMinimize();

    // Add user message
    addMessage(message, 'user-message');
    chatInput.value = '';

    // Scroll to bottom
    chatMessages.scrollTop = chatMessages.scrollHeight;

    try {
      // Make API call to Rails backend
      const response = await sendMessageToBackend(message);
      addMessage(response, 'bot-message');
    } catch (error) {
      addMessage('Sorry, something went wrong.', 'bot-message');
    }

    // Scroll to bottom after response
    chatMessages.scrollTop = chatMessages.scrollHeight;
  });

  function addMessage(text, type) {
    const messageDiv = document.createElement('div');
    messageDiv.classList.add('chat-message', type);

    const messageContent = document.createElement('div');
    messageContent.classList.add(
      type === 'user-message' ? 'bg-blue-100' : 'bg-gray-100',
      'p-3',
      'rounded-lg'
    );
    messageContent.textContent = text;

    messageDiv.appendChild(messageContent);
    chatMessages.appendChild(messageDiv);
  }

  // Send message to Rails backend
  async function sendMessageToBackend(message) {
    const response = await fetch('/chat/message', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content // Rails CSRF protection
      },
      body: JSON.stringify({ message: message })
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data.response; // Extract the response text from JSON
  }
});
