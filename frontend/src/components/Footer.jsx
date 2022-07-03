import React from 'react';
import ForumHouseIcon from '../static/icons/forumhouse.ico';
import VkIcon from '../static/icons/vk.ico';

function Footer() {
    return (
        <div className="container fixed-bottom">
            <footer className="d-flex flex-wrap justify-content-between align-items-center py-3 border-top border-1 border-dark border-opacity-25">
                <div className="col-md-6 d-flex align-items-center">
                    <a href="/" className=" me-4 mb-md-0 text-muted text-decoration-none lh-1 fs-3">
                        <b>MyCalcs</b>
                    </a>
                    <span className="mb-md-0 text-muted"><p className="footer-copyright">Copyright © 2017-2022,</p><p className="footer-copyright"> Vadim Godunko</p></span>
                </div>

                <ul className="nav col-md-6 justify-content-end list-unstyled d-flex">
                    
                    <li className="ms-3">
                        <a className="text-muted" href="https://vk.com/club205227623">
                            <img rel="icon" src={VkIcon} type="image/x-icon" className="bi" width="30" height="30"></img>
                        </a>
                    </li>
                    <li className="ms-3">
                        <a className="text-muted" href="https://www.forumhouse.ru/threads/424675/">
                            <img rel="icon" src={ForumHouseIcon} type="image/x-icon" className="bi" width="30" height="30"></img>
                        </a>
                    </li>
                </ul>
            </footer>
        </div>
    );
}

export default Footer;
