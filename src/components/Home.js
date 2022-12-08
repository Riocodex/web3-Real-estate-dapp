import { ethers } from 'ethers';
import { useEffect, useState } from 'react';

import close from '../assets/close.svg';

const Home = ({ home, provider, escrow, toggleProp }) => {

    return (
        <div className="home">
            <div className='home__details'>
                <div className='home__image'>
                    <img src={home.image} alt="Home" />
                </div>
                <button onClick={toggleProp} className="home__close">
                    <img src={close} alt='close'/>
                </button>
            </div>
            
        </div>
    );
}

export default Home;
