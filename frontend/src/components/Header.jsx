import React from 'react';


function Header() {
    
    return (
        <nav className="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <div className="container-fluid">
                {/*бургер+лого*/}
                <div className="d-flex navbar-logo">
                    <button  className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span alt="VK" className="navbar-toggler-icon"></span>
                    </button>
                    <a className="navbar-brand" href="#">MyCalcs</a>
                </div>
                {/*кнопка входа*/}
                <button className="navbar-login" type="button">
                    <svg alt="Login" xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 512 512"><path fill="#9d9d9d" d="M416 32h-64c-17.67 0-32 14.33-32 32s14.33 32 32 32h64c17.67 0 32 14.33 32 32v256c0 17.67-14.33 32-32 32h-64c-17.67 0-32 14.33-32 32s14.33 32 32 32h64c53.02 0 96-42.98 96-96V128C512 74.98 469 32 416 32zM342.6 233.4l-128-128c-12.51-12.51-32.76-12.49-45.25 0c-12.5 12.5-12.5 32.75 0 45.25L242.8 224H32C14.31 224 0 238.3 0 256s14.31 32 32 32h210.8l-73.38 73.38c-12.5 12.5-12.5 32.75 0 45.25s32.75 12.5 45.25 0l128-128C355.1 266.1 355.1 245.9 342.6 233.4z" /></svg>
                </button>
                {/*меню*/}
                <div className="collapse navbar-collapse navbar-links" id="navbarNav">
                    <ul className="navbar-nav me-auto mb-2 mb-lg-0 " styk>
                        <li className="nav-item">
                            <a className="nav-link" href="#">Деревянные конструкции</a>
                        </li>
                        <li className="nav-item">
                            <a className="nav-link" href="#">Стропильные системы</a>
                        </li>
                        <li className="nav-item">
                            <a className="nav-link" href="#">Фундаменты и основания</a>
                        </li>
                        <li className="nav-item">
                            <a className="nav-link" href="#">Нагрузки и воздействия</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

    );
}

export default Header;
