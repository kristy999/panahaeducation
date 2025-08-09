<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Help Section</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            #searchBox {
                width: 300px;
                padding: 8px;
                font-size: 16px;
            }
            .help-entry {
                border-bottom: 1px solid #ccc;
                padding: 10px 0;
            }
            .question {
                font-weight: bold;
            }
            .answer {
                margin-top: 5px;
                white-space: pre-wrap;
            }
            .clue {
                font-style: italic;
                color: #555;
                margin-top: 3px;
            }
        </style>
    </head>
    <body>
        <h2>Help Section</h2>
        <input type="text" id="searchBox" placeholder="Search help topics..." autocomplete="off" />

        <div id="results"></div>

        <script type="text/javascript">

            const searchBox = document.getElementById('searchBox');
            const resultsDiv = document.getElementById('results');

            searchBox.addEventListener('input', function () {
                const query = this.value.trim();

                if (query.length === 0) {
                    resultsDiv.innerHTML = '';
                    return;
                }

                fetch('help?query=' + encodeURIComponent(query))
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Network response was not ok');
                            return response.json();
                        })
                        .then(data => {
                            if (data.length === 0) {
                                resultsDiv.innerHTML = '<p>No results found.</p>';
                                return;
                            }

                            resultsDiv.innerHTML = data.map(entry => `
                             <div class="help-entry">
                                <div class="question">
                                     <a href="helpDetail.jsp?id=\${entry.id}" target="_blank">\${escapeHtml(entry.question)}</a>
                                 </div>
                                <div class="answer">\${escapeHtml(entry.answer)}</div>
                                 <div class="clue">\${entry.clue ? 'Clue: ' + escapeHtml(entry.clue) : ''}</div>
                                </div>
                                `).join('');
                        })
                        .catch(err => {
                            resultsDiv.innerHTML = '<p>Error loading results.</p>';
                            console.error(err);
                        });
            });

            // Basic HTML escape to prevent XSS
            function escapeHtml(text) {
                if (!text)
                    return '';
                return text.replace(/[&<>"']/g, function (m) {
                    return {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'}[m];
                });
            }
        </script>
    </body>
</html>
