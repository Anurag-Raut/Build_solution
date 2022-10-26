import java.util.Scanner; public class arr102 {
    public static void main(String[] args) { int n;
    int sum=0;
    
    int[] A=new int[10];
    
    Scanner sc=new Scanner(System.in);
    
    System.out.println("enter number of elements");
    n=sc.nextInt(); for(int i=0;i<n;i++){
    A[i]=sc.nextInt();
    
    }
    
    for(int k=0;k<n;k++){ sum=sum+A[k];
    }
    
    for(int j=0;j<n;j++){ int temp=A[j]; A[j]=sum-temp;

        System.out.print(A[j]);

System.out.print(" ");

}

sc.close();

}

}

    