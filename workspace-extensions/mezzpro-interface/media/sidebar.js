(function() {
    const vscode = acquireVsCodeApi();

    document.querySelectorAll('li').forEach(li => {
        li.addEventListener('click', () => {
            const page = li.getAttribute('data-page');
            vscode.postMessage({
                command: 'mezzpro.showPage',
                page: page
            });
        });
    });
}());