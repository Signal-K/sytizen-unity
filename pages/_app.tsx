import "../styles/globals.css";
import type { AppProps } from "next/app";
import { ChainId, ThirdwebProvider } from "@thirdweb-dev/react";
import { useEffect, useState } from "react";

// Supabase-relevant imports
import { supabase } from './supabaseClient';
//import Auth from './components/Auth'; -> Add these two later. Probably would be better to add them to `play` page (along with client)
//import Account from './components/Account';

function MyApp({ Component, pageProps }: AppProps) {
  const [session, setSession] = useState(null);

  useEffect(() =>{
    setSession(supabase.auth.session())
    supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
    })
  }, [])

  return (
    <ThirdwebProvider desiredChainId={ChainId.Mumbai}>
      <Component {...pageProps} />
    </ThirdwebProvider>
  );
}

export default MyApp;
