import React from 'react'
import Link from 'next/link'
import styles from '../styles/Header.module.css'

const Header: React.FC = () => {
  return (
    <header className={styles.header}>
      <div className={styles.container}>
        <Link href="/" className={styles.logo}>
          <span className={styles.logoText}>🎵 MelodyChain</span>
        </Link>

        <nav className={styles.nav}>
          <Link href="/browse" className={styles.navLink}>
            Browse
          </Link>
          <Link href="/upload" className={styles.navLink}>
            Upload
          </Link>
          <Link href="/profile" className={styles.navLink}>
            My Music
          </Link>
        </nav>

        <div className={styles.connectSection}>
          <button className={styles.connectButton}>
            Connect Wallet
          </button>
        </div>
      </div>
    </header>
  )
}

export default Header